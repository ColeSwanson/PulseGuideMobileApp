//
//  ContentView.swift
//  PulseGuideWatchApp Watch App
//
//  Created by Swanson, Cole T on 3/6/25.
//

import SwiftUI
import Combine
import WatchConnectivity


struct ContentView: View {
    @State private var startCPR = false // For opening app
    @State private var startTimer = false // For opening app
    @State private var cpm: Int = Int.random(in: 90...130)  // Random initial value for CPM
    @State private var inches: Double = Double.random(in: 1.9...2.5)  // Random initial value for Inches
    @State private var timerSubscription: Cancellable? = nil  // Timer subscription for Combine
    
    // WatchConnectivity session
        let session = WCSession.default
        
        init() {
            // Ensure WCSession is activated
            if WCSession.default.isReachable {
                session.activate()
            }
        }

    // Start the timer to update CPM and Inches values every second
    func startUpdating() {
        // Create a timer that fires every second
        let timerPublisher = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
        
        // Subscribe to the timer publisher
        timerSubscription = timerPublisher.sink { _ in
            // Randomly update CPM and Inches every second
            cpm = Int.random(in: 90...130)
            inches = Double.random(in: 1.9...2.5)
            sendDataToPhone(rate: self.cpm, depth: self.inches, timer: self.startTimer)
        }
    }

    // Stop the timer
    func stopUpdating() {
        timerSubscription?.cancel()
        timerSubscription = nil
    }

    var body: some View {
        if startCPR {
            VStack(spacing: 10) {
                
                // "END" label at the top
                Button(action: {
                    // Fetch or generate data when button is pressed
                    self.startCPR = false
                    self.startTimer = false
                    sendDataToPhone(rate: self.cpm, depth: self.inches, timer: self.startTimer)
            
                }) {
                    Text("< END")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.orange)
                        .frame(maxWidth: 200, maxHeight: 10)
                        //.padding(.top, 10)
                }
                .padding(.top, 5)
    
                
                // Top section (Orange background and CPM)
                VStack {
                    if (cpm < 100){
                        Text("FASTER")
                            .font(.system(size: 30, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, maxHeight: 50)
                            .background(Color.red)
                            .cornerRadius(10)
                        
                    } else if (cpm > 120){
                        Text("SLOWER")
                            .font(.system(size: 30, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, maxHeight: 50)
                            .background(Color.red)
                            .cornerRadius(10)
                    } else{
                        Text("\(cpm)")
                            .font(.system(size: 50, weight: .bold, design: .rounded))
                            .foregroundColor(.orange)
                        Text("CPM")
                            .font(.system(size: 20, weight: .medium, design: .rounded))
                            .foregroundColor(.orange)
                    }
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white)
                .cornerRadius(10)
                
                // Bottom section (Green background and Inches)
                VStack {
                    if (inches < 2){
                        Text("DEEPER")
                            .font(.system(size: 30, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, maxHeight: 50)
                            .background(Color.red)
                            .cornerRadius(10)
                    } else if (inches > 2.4){
                        Text("SHALLOWER")
                            .font(.system(size: 30, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, maxHeight: 50)
                            .background(Color.red)
                            .cornerRadius(10)
                    } else {
                        Text(String(format: "%.1f", inches))  // Formatting to 1 decimal point
                            .font(.system(size: 50, weight: .bold, design: .rounded))
                            .foregroundColor(.green)
                        Text("In")
                            .font(.system(size: 20, weight: .medium, design: .rounded))
                            .foregroundColor(.green)
                    }
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white)
                .cornerRadius(10)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)  // Set background of entire screen to white
            .edgesIgnoringSafeArea(.all)  // Ignore safe area to cover the whole screen
            .onAppear {
                startUpdating()  // Start the timer when the view appears
            }
            .onDisappear {
                stopUpdating()  // Stop the timer when the view disappears
            }
        }
        else {
            Button(action: {
                // Fetch or generate data when button is pressed
                self.startCPR = true
                self.startTimer = true
                //sendDataToPhone(rate: self.cpm, depth: self.inches)
            }) {
                Text("Start CPR")
                    .font(.title)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.red)
                    .cornerRadius(30)
            }
        }
    }
    // Function to send data to the phone app
    func sendDataToPhone(rate: Int, depth: Double, timer: Bool) {
            if session.isReachable {
                let message = ["Rate":String(rate), "Depth":String(depth), "Timer":String(timer)]
                session.sendMessage(message, replyHandler: nil, errorHandler: nil)
            } else {
                print("Phone is not reachable")
            }
        }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("Apple Watch Series 8 - 45mm")
    }
}
