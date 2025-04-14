import SwiftUI
import WatchConnectivity

struct ContentView: View {
    @ObservedObject var sessionDelegate = PhoneSessionDelegate.shared

    var body: some View {
        VStack(spacing: 20) {
            Text("📱 iPhone Receiving CPM")
                .font(.title)

            Text(sessionDelegate.latestMessage)
                .font(.largeTitle)
                .foregroundColor(.green)

            Button("Send Test Message to Watch") {
                if WCSession.default.isReachable {
                    WCSession.default.sendMessage(["msg": "Hello from iPhone"], replyHandler: nil) { error in
                        print("Error sending to watch: \(error.localizedDescription)")
                    }
                }
            }
        }
        .padding()
    }
}
