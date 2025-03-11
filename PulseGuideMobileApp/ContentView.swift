//
//  ContentView.swift
//  PhoneAppPrototype
//
//  Created by Faith Maue on 12/10/24.
//

import SwiftUI
import UIKit
import WatchConnectivity

class ViewController: NSObject, ObservableObject, WCSessionDelegate
{
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: ((any Error)?)) {
        if let error = error {
            print("WCSession activation failed with error: \(error)")
        } else {
            print("WCSession activated with state: \(activationState.rawValue)")
        }
    }
    
    func sessionDidDeactivate(_ session: WCSession) {}
    func sessionDidBecomeInactive(_ session: WCSession) {}
    
    // WCSession to receive messages
    var session: WCSession!
    
    @Published var receivedRate: Int = 110
    @Published var receivedDepth: Double = 2.20
    @Published var receivedTimer: Bool = false
    
    override init() {
        super.init()
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }
        
        
        func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
            DispatchQueue.main.async {
                if let rateValue = message["rateValue"] as? Int, let depthValue = message["depthValue"] as? Double, let timerValue = message["timerValue"] as? Bool {
                    self.receivedRate = rateValue
                    self.receivedDepth = depthValue
                    self.receivedTimer = timerValue
                }
            }
        }
}


struct ContentView: View {
    @StateObject private var sessionManager = ViewController()
    //@State private var speed: Int = 110
    //@State private var depth: Double = 2.20
    @State private var timer: Timer? = nil
    @State private var isRunning: Bool = false
    @State private var elapsedTime: TimeInterval = 0
    
    var body: some View {
        VStack {
        // Show elapsed time in minutes and seconds
            let speed: Int = sessionManager.receivedRate
            let depth: Double = sessionManager.receivedDepth
            let runTimer: Bool = sessionManager.receivedTimer
            
            Text("\(formatTime(elapsedTime))")
                .font(.largeTitle)
            .padding(.bottom)
            
            ZStack {
                // Draw the speedometer dial
                Circle()
                    .trim(from: 0, to: 0.5)
                    .stroke(lineWidth: 20)
                    .rotationEffect(.radians(.pi))
                    .foregroundColor(Color.gray.opacity(0.3))

                // Draw the ticks
                ForEach(0..<5, id: \.self) { tick in
                    let angle = Angle(degrees: Double(tick) * 45 - 90)

                    Rectangle()
                        .fill(tick % 2 == 0 ? Color.gray : Color.black)
                        .frame(width: tick % 2 == 0 ? 2 : 4, height: tick % 2 == 0 ? 10 : 20)
                        .offset(y: -140)
                        .rotationEffect(angle)
                }
                // Draw the needle
                if speed < 100 || speed > 120{
                    Rectangle()
                        .fill(Color.red)
                        .frame(width: 4, height: 100)
                        .offset(y: -50)
                        .rotationEffect(Angle(degrees: Double(speed) * 4.5 - 135))
                }else if speed <= 102 || speed >= 118{
                    Rectangle()
                        .fill(Color.yellow)
                        .frame(width: 4, height: 100)
                        .offset(y: -50)
                        .rotationEffect(Angle(degrees: Double(speed) * 4.5 - 135))
                }else{
                    Rectangle()
                        .fill(Color.green)
                        .frame(width: 4, height: 100)
                        .offset(y: -50)
                        .rotationEffect(Angle(degrees: Double(speed) * 4.5 - 135))
                }

                // Draw the center circle
                Circle()
                    .fill(Color.black)
                    .frame(width: 20, height: 20)
                
                Text("100")
                    .font(.body)
                    .bold()
                    .offset(x:-120, y:-130)
                
                Text("120")
                    .font(.body)
                    .bold()
                    .offset(x:120, y:-130)
                
                
               // Show the current speed
                if speed < 100 || speed > 120{
                    Text("\(Int(speed)) CPM")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.red)
                        .offset(y: 50)
                }else if speed <= 102 || speed >= 118{
                    Text("\(Int(speed)) CPM")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.yellow)
                        .offset(y: 50)
                }else{
                    Text("\(Int(speed)) CPM")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.green)
                        .offset(y: 50)
                }
                
                Text("Compression Rate")
                    .font(.title)
                    .bold()
                    .offset(y: 100)
            }
            .frame(width: 300, height: 300)
            
            ZStack{
                ZStack(alignment: .bottom) {
                        Rectangle()
                            .frame(width: 110, height: 200)
                            .foregroundColor(Color.gray.opacity(0.3))
                                
                        Rectangle()
                        .frame(width: 110, height: CGFloat((depth-1.80) * 250))
                        .foregroundColor(depthColor(depth:depth))
                            .animation(.easeInOut, value: depth)
                    }
                    .padding()
                
                // Draw the ticks
                ForEach(0..<5, id: \.self) { tick in
                    let offset = Double(tick) * (-50) + 100

                    Rectangle()
                        .fill(tick % 2 == 0 ? Color.gray : Color.black)
                        .frame(width: tick % 2 == 0 ? 10 : 110, height: tick % 2 == 0 ? 3 : 7)
                        .offset(x: tick % 2 == 0 ? 50 : 0, y: offset)
                }
                
                Text("2.0 in")
                    .font(.body)
                    .bold()
                    .offset(x:80, y:50)
                
                Text("2.4 in")
                    .font(.body)
                    .bold()
                    .offset(x:80, y:-50)
                
                Text("Compression Depth")
                    .font(.title)
                    .bold()
                    .offset(y:130)
                
                // Show the current speed
                if (depth) < 2 || depth > 2.4{
                    Text("\(depth, specifier: "%.2f") in.")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.red)
                        .offset(y: -150)
                }else if depth >= 2.3 || depth <= 2.10{
                    Text("\(depth, specifier: "%.2f") in.")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.yellow)
                        .offset(y:-150)
                }else{
                    Text("\(depth, specifier: "%.2f") in.")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.green)
                        .offset(y: -150)
                }

            }
            .frame(width: 300, height: 300)
               
            // Start/Stop Timer
            .onAppear{
                if runTimer {
                    startTimer()
                }
                else {
                    stopTimer()
                }
            }
            /*Button(action: {
                if isRunning {
                    stopTimer()
                } else {
                    startTimer()
                }
            }) {
                Text(isRunning ? "Stop Timer" : "Start Timer")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(isRunning ? Color.red : Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding(.horizontal)
            }*/
        }
    }
    
    private func depthColor(depth:Double) -> Color {
        if (depth) < 2 || depth > 2.4{
            return Color.red
        }
        else if depth >= 2.3 || depth <= 2.10 {
            return Color.yellow
        }
        else {
            return Color.green
        }
        
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
            let minutes = Int(time) / 60
            let seconds = Int(time) % 60
            return String(format: "%02d:%02d", minutes, seconds)
    }

    private func startTimer() {
        isRunning = true
        elapsedTime = 0
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            elapsedTime += 0.1
        }
    }

    private func stopTimer() {
        isRunning = false
        timer?.invalidate()
        timer = nil
    }
}


#Preview {
    ContentView()
}
