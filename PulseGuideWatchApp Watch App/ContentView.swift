import SwiftUI
import WatchConnectivity

struct ContentView: View {
    @StateObject private var motionManager = MotionManager()

    var body: some View {
        VStack {
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
            }
        }
    }
}
