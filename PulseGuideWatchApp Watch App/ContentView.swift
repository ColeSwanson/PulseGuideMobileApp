import SwiftUI
import WatchConnectivity

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Watch App")
            Button("Send to iPhone") {
                if WCSession.default.isReachable {
                    WCSession.default.sendMessage(["msg": "Hello from Watch"], replyHandler: nil, errorHandler: { error in
                        print("Error sending to phone: \(error)")
                    })
                } else {
                    print("iPhone not reachable")
                }
            }
        }
    }
}
