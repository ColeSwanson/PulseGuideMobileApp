
import SwiftUI

struct ContentView: View {
    @StateObject private var motionManager = MotionManager()

    var body: some View {
        VStack {
            Text("Motion Data Logger")
                .font(.headline)
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

            Button("Export CSV") {
                motionManager.exportCSV()
            }
            .padding()
        }
    }
}
