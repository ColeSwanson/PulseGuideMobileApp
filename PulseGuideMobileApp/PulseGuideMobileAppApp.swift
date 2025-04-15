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

    @Published var cpm: Double = 100
    @Published var depth: Double = 2

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("📱 WCSession activated with state: \(activationState.rawValue)")
        if let error = error {
            print("❌ Activation error: \(error.localizedDescription)")
        }
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            if let cpm = message["cpm"] as? Double {
                self.cpm = cpm
            }
            if let depth = message["depth"] as? Double {
                self.depth = depth
            }
        }
    }

    func sessionDidBecomeInactive(_ session: WCSession) {}
    func sessionDidDeactivate(_ session: WCSession) {}
}

