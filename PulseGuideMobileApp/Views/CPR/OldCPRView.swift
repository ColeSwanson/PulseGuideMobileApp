//
//  CPRView.swift
//  PhoneAppPrototype
//
//  Created by Faith Maue on 12/10/24.
//

import SwiftUI

struct OldCPRView: View {
    @State private var speed: Double = 100
    @State private var depth: Double = 2.20
    @State private var timer: Timer? = nil
    @State private var isRunning: Bool = false
    @State private var elapsedTime: TimeInterval = 0

    var body: some View {
        VStack {
        // Show elapsed time in minutes and seconds
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
                        .rotationEffect(Angle(degrees: speed * 4.5 - 90))
                }else if speed <= 102 || speed >= 118{
                    Rectangle()
                        .fill(Color.yellow)
                        .frame(width: 4, height: 100)
                        .offset(y: -50)
                        .rotationEffect(Angle(degrees: speed * 4.5 - 90))
                }else{
                    Rectangle()
                        .fill(Color.green)
                        .frame(width: 4, height: 100)
                        .offset(y: -50)
                        .rotationEffect(Angle(degrees: speed * 4.5 - 90))
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
                
                    
                Text("Compression Rate")
                    .font(.title)
                    .bold()
                    .offset(y: 50)
                
               // Show the current speed
                if speed < 100 || speed > 120{
                    Text("\(Int(speed)) CPM")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.red)
                        .offset(y: 100)
                }else if speed <= 102 || speed >= 118{
                    Text("\(Int(speed)) CPM")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.yellow)
                        .offset(y: 100)
                }else{
                    Text("\(Int(speed)) CPM")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.green)
                        .offset(y: 100)
                }
            }
            .frame(width: 300, height: 300)
            
            ZStack{
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width:110, height:200)

                
                // Draw the bar
                if depth < 2 || depth > 2.4{
                    Rectangle()
                        .fill(Color.red)
                        .frame(width: 110, height: 2
                               * depth)
                        .offset(y: depth * (-1) + 100)
                        //.offset(y: depth * (-2) + 100)
                }else if depth >= 2.35 || depth <= 2.05{
                    Rectangle()
                        .fill(Color.yellow)
                        .frame(width: 110, height: 2 * depth)
                        .offset(y: depth * (-1) + 100)
                        //.offset(y: depth * (-2) + 100)
                }else{
                    Rectangle()
                        .fill(Color.green)
                        .frame(width: 110, height: 2 * depth)
                        .offset(y: depth * (-1) + 100)
                        //.offset(y: depth * (-2) + 100)
                }
                
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
                    Text("\(Int(depth)) In.")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.red)
                        .offset(y: -150)
                }else if depth >= 2.35 || depth <= 2.05{
                    Text("\(Int(depth)) In.")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.yellow)
                        .offset(y:-150)
                }else{
                    Text("\(Int(depth)) In.")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.green)
                        .offset(y: -150)
                }

            }
            .frame(width: 300, height: 300)
               
            // Start/Stop Timer Button
            Button(action: {
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
            }
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
    OldCPRView()
}
