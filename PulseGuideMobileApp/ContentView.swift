import SwiftUI
import WatchConnectivity

struct ContentView: View {
    @ObservedObject var sessionDelegate = PhoneSessionDelegate.shared

    var body: some View {
        VStack(spacing: 20) {
            Text("📱 iPhone App Running")
                .font(.title)

            Text(sessionDelegate.latestMessage)
                .foregroundColor(.blue)
                .padding()
                .multilineTextAlignment(.center)

            Button("Send Message to Watch") {
                if WCSession.default.isReachable {
                    WCSession.default.sendMessage(["msg": "Hello from iPhone"], replyHandler: nil) { error in
                        print("📱 Error sending to watch: \(error.localizedDescription)")
                    }
                } else {
                    print("📱 Watch not reachable")
                }
            }
        }
        .padding()
    }
}

