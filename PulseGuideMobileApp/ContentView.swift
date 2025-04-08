import SwiftUI
import WatchConnectivity

struct ContentView: View {
    var body: some View {
        VStack {
            Text("iPhone App")
            Button("Send Message to Watch") {
                if WCSession.default.isReachable {
                    WCSession.default.sendMessage(["msg": "Hello from iPhone"], replyHandler: nil, errorHandler: { error in
                        print("Error sending to watch: \(error)")
                    })
                } else {
                    print("Watch not reachable")
                }
            }
        }
        .padding()
    }
}
