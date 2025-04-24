import Foundation
import CoreMotion
import WatchConnectivity

class MotionManager: NSObject, ObservableObject, WCSessionDelegate {
    @available(watchOS 2.0, *)
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("⌚️ WCSession activated: \(activationState.rawValue)")
    }

    @available(watchOS 2.0, *)
    func sessionReachabilityDidChange(_ session: WCSession) {
        print("⌚️ Session reachability changed: \(session.isReachable)")
    }
    private var motionManager = CMMotionManager()
    private var timer: Timer?
    private var updateTimer: Timer? // For updating CPM every 3 seconds

    @Published var acceleration: (x: Double, y: Double, z: Double) = (0, 0, 0)
    @Published var compressionRate: Double = 0.0 // Overall CPM
    @Published var rollingCPM: Double = 0.0 // CPM based on last 3 peaks
    @Published var prevAcceleration: (x: Double, y: Double, z: Double) = (0, 0, 0)
    private var depth: Double = 0.0
    @Published var rollingDepth: Double = 0.0

    private var dataLog: [(timestamp: TimeInterval, ax: Double, ay: Double, az: Double, aMag: Double)] = []
    private var peakCount = 0
    private let compressionThreshold: Double = 1.5 // Acceleration magnitude threshold
    private var isAboveThreshold = false // Tracks if we are in a peak

    private var rollingWindow: [Double] = [] // Stores recent acceleration magnitudes
    private let rollingWindowSize = 5 // Number of samples to average

    private var peakTimestamps: [TimeInterval] = [] // Timestamps of the last 3 peaks

    let sampleRate = 0.01 // 10ms per sample

    func startRecording() {
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
        print("Starting data collection...")
        peakCount = 0 // Reset peak counter
        isAboveThreshold = false // Ensure fresh start
        rollingWindow.removeAll() // Clear previous rolling data
        dataLog.removeAll() // Clear previous data log
        peakTimestamps.removeAll() // Clear previous peak timestamps

        // Check if accelerometer is available
        print("Accelerometer Available: \(motionManager.isAccelerometerAvailable)")

        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = sampleRate
            motionManager.startAccelerometerUpdates()

            // Timer to update the rolling CPM every 3 seconds
            updateTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
                self.updateRollingCPM()
            }

            timer = Timer.scheduledTimer(withTimeInterval: sampleRate, repeats: true) { _ in
                guard let accelData = self.motionManager.accelerometerData else {
                    print("No accelerometer data available yet.")
                    return
                }

                let timestamp = Date().timeIntervalSince1970
                let ax = accelData.acceleration.x
                let ay = accelData.acceleration.y
                let az = accelData.acceleration.z
                let rawMag = sqrt(ax * ax + ay * ay + az * az) // Raw acceleration magnitude

                // Apply Rolling Average Filter
                self.rollingWindow.append(rawMag)
                if self.rollingWindow.count > self.rollingWindowSize {
                    self.rollingWindow.removeFirst() // Keep window size fixed
                }
                let smoothedMag = self.rollingWindow.reduce(0, +) / Double(self.rollingWindow.count)

                self.acceleration = (ax, ay, az)
                self.dataLog.append((timestamp, ax, ay, az, smoothedMag))

                // Peak detection: Count only when crossing from below to above threshold
                if smoothedMag > self.compressionThreshold {
                    if !self.isAboveThreshold {
                        self.peakCount += 1 // Only count when crossing above
                        self.isAboveThreshold = true
                        self.peakTimestamps.append(timestamp) // Add peak timestamp

                        // Maintain only the last 3 peaks in the window
                        if self.peakTimestamps.count > 3 {
                            self.peakTimestamps.removeFirst()
                        }
                    }
                } else {
                    self.isAboveThreshold = false // Reset when below threshold
                }
                
                let mag = sqrt(self.acceleration.x * self.acceleration.x + self.acceleration.y * self.acceleration.y + self.acceleration.z * self.acceleration.z) - 1
                let prevMag = sqrt(self.prevAcceleration.x * self.prevAcceleration.x + self.prevAcceleration.y * self.prevAcceleration.y + self.prevAcceleration.z * self.prevAcceleration.z) - 1
                
                let displacement = (mag * 0.01 * 0.01) * 9.81 * 39.37 * 5;
                print(displacement)
                
                if(displacement > 0)
                {
                    self.depth = self.depth + displacement
                }
                else if(self.depth > 1)
                {
                    print("Depth: ", self.depth)
                    self.rollingDepth = self.depth;
                    self.depth = 0
                }
                
                self.prevAcceleration = (ax, ay, az)

                // print("Data collected: \(self.dataLog.count) samples, Smoothed Accel Mag: \(smoothedMag)")
            }
        } else {
            print("🚨 Accelerometer is NOT available on this device! 🚨")
        }
    }

    func stopRecording() {
        motionManager.stopAccelerometerUpdates()
        timer?.invalidate()
        updateTimer?.invalidate() // Stop the CPM update timer

        if let startTime = dataLog.first?.timestamp, let endTime = dataLog.last?.timestamp {
            let duration = endTime - startTime // Time in seconds
            let durationMinutes = duration / 60.0 // Convert to minutes

            let compressionsPerMinute = durationMinutes > 0 ? Double(peakCount) / durationMinutes : 0.0
            compressionRate = compressionsPerMinute // Update @Published variable

            print("🚀 Data collection stopped.")
            print("Total samples collected: \(dataLog.count)")
            print("⏱️ Total duration: \(String(format: "%.2f", duration)) seconds")
            print("📈 Total peaks detected: \(peakCount)")
            print("💓 Compressions per minute (CPM): \(String(format: "%.2f", compressionsPerMinute))")
        } else {
            print("⚠️ No data collected or invalid timestamps.")
        }
    }

    private func updateRollingCPM() {
        guard peakTimestamps.count == 3 else { return }

        let timeSpan = peakTimestamps.last! - peakTimestamps.first!
        if timeSpan > 0 {
            let cpm = 60.0 / (timeSpan / 2.0) // 2 intervals between 3 peaks
            rollingCPM = cpm
            //rollingCPM = 75
            print("💓 Live Rolling CPM (last 3 peaks): \(String(format: "%.2f", rollingCPM))")

            // Send to iPhone via WCSession
            if WCSession.default.isReachable {
                WCSession.default.sendMessage(["cpm": cpm, "depth": self.rollingDepth], replyHandler: nil) { error in
                    print("❌ Failed to send CPM to iPhone: \(error.localizedDescription)")
                }
            } else {
                print("⚠️ iPhone not reachable, couldn't send CPM")
            }
        }
    }
}
