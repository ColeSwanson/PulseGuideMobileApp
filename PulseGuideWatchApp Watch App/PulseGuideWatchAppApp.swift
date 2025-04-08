import SwiftUI
import WatchConnectivity

@main
struct PulseGuideWatchAppApp: App {
    
    init() {
        if WCSession.isSupported() {
            WCSession.default.delegate = WatchSessionDelegate.shared
            WCSession.default.activate()
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

// Singleton delegate
class WatchSessionDelegate: NSObject, WCSessionDelegate {
    static let shared = WatchSessionDelegate()

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("Watch: WCSession activated: \(activationState.rawValue)")
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("Watch received message: \(message)")
    }
}
