import SwiftUI
import WatchConnectivity
import Foundation

@main
struct PulseGuideMobileAppApp: App {
    init() {
        if WCSession.isSupported() {
            WCSession.default.delegate = PhoneSessionDelegate.shared
            WCSession.default.activate()
            print("phone session activated")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
// Singleton delegate
class PhoneSessionDelegate: NSObject, WCSessionDelegate, ObservableObject {
    static let shared = PhoneSessionDelegate()

    @Published var latestMessage: String = "No message yet"

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("📱 WCSession activated with state: \(activationState.rawValue)")
        if let error = error {
            print("❌ Activation error: \(error.localizedDescription)")
        }
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            if let cpm = message["cpm"] as? Double {
                self.latestMessage = String(format: "CPM: %.2f", cpm)
            } else if let msg = message["msg"] as? String {
                self.latestMessage = "Received: \(msg)"
            } else {
                self.latestMessage = "Unknown message received"
            }
        }
    }

    func sessionDidBecomeInactive(_ session: WCSession) {}
    func sessionDidDeactivate(_ session: WCSession) {}
}

