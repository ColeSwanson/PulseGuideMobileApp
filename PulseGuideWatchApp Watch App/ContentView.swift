import SwiftUI
import WatchConnectivity

struct ContentView: View {
    @StateObject private var motionManager = MotionManager()
    @State private var startCPR = false // For opening app
    @State private var inches: Double = 2.20  // Random initial value for Inches


    var body: some View {
        /*VStack {
            Text("CPR Compression Rate")
                .font(.headline)
                .padding()

            Text("Live CPM (last 3 peaks):")
                .font(.subheadline)

            Text("\(motionManager.rollingCPM, specifier: "%.2f") CPM")
                .font(.largeTitle)
                .padding()

            HStack {
                Button("Start") {
                    motionManager.startRecording()
                }
                .padding()

                Button("Stop") {
                    motionManager.stopRecording()
                }
                .padding()
            }*/
            if startCPR {
                        VStack(spacing: 10) {
                            
                            // "END" label at the top
                            Button(action: {
                                // Fetch or generate data when button is pressed
                                self.startCPR = false
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
                                if (motionManager.rollingCPM < 100){
                                    Text("FASTER")
                                        .font(.system(size: 30, weight: .bold, design: .rounded))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity, maxHeight: 50)
                                        .background(Color.red)
                                        .cornerRadius(10)
                                    
                                } else if (motionManager.rollingCPM > 120){
                                    Text("SLOWER")
                                        .font(.system(size: 30, weight: .bold, design: .rounded))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity, maxHeight: 50)
                                        .background(Color.red)
                                        .cornerRadius(10)
                                } else{
                                    Text("\(motionManager.rollingCPM, specifier: "%.2f")")
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
                                if (motionManager.rollingDepth < 2){
                                    Text("DEEPER")
                                        .font(.system(size: 30, weight: .bold, design: .rounded))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity, maxHeight: 50)
                                        .background(Color.red)
                                        .cornerRadius(10)
                                } else if (motionManager.rollingDepth > 2.4){
                                    Text("SHALLOWER")
                                        .font(.system(size: 30, weight: .bold, design: .rounded))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity, maxHeight: 50)
                                        .background(Color.red)
                                        .cornerRadius(10)
                                } else {
                                    Text(String(format: "%.1f", motionManager.rollingDepth))  // Formatting to 1 decimal point
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
                            WKExtension.shared().isFrontmostTimeoutExtended = true
                            motionManager.startRecording()  // Start the timer when the view appears
                        }
                        .onDisappear {
                            motionManager.stopRecording() // Stop the timer when the view disappears
                        }
                    }
                    else {
                        Button(action: {
                            // Fetch or generate data when button is pressed
                            self.startCPR = true
                        }) {
                            Text("Start CPR")
                                .font(.title)
                                .padding()
                                .foregroundColor(.white)
                                .background(Color.red)
                                .cornerRadius(30)
                        }
                    }
 //       }
    }
}
