import Foundation
import CoreMotion

class MotionManager: ObservableObject {
    private var motionManager = CMMotionManager()
    private var timer: Timer?

    @Published var acceleration: (x: Double, y: Double, z: Double) = (0, 0, 0)

    private var dataLog: [(timestamp: TimeInterval, ax: Double, ay: Double, az: Double, aMag: Double)] = []
    private var peakCount = 0
    private let compressionThreshold: Double = 1.5 // Acceleration magnitude threshold
    private var isAboveThreshold = false // Tracks if we are in a peak

    let sampleRate = 0.01 // 10ms per sample

    func startRecording() {
        print("Starting data collection...")
        peakCount = 0 // Reset peak counter
        isAboveThreshold = false // Ensure fresh start

        // Check if accelerometer is available
        print("Accelerometer Available: \(motionManager.isAccelerometerAvailable)")

        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = sampleRate
            motionManager.startAccelerometerUpdates()

            timer = Timer.scheduledTimer(withTimeInterval: sampleRate, repeats: true) { _ in
                guard let accelData = self.motionManager.accelerometerData else {
                    print("No accelerometer data available yet.")
                    return
                }

                let timestamp = Date().timeIntervalSince1970
                let ax = accelData.acceleration.x
                let ay = accelData.acceleration.y
                let az = accelData.acceleration.z
                let aMag = sqrt(ax * ax + ay * ay + az * az) // Compute acceleration magnitude

                self.acceleration = (ax, ay, az)
                self.dataLog.append((timestamp, ax, ay, az, aMag))

                // Peak detection: Count only when crossing from below to above threshold
                if aMag > self.compressionThreshold {
                    if !self.isAboveThreshold {
                        self.peakCount += 1 // Only count when crossing above
                        self.isAboveThreshold = true
                    }
                } else {
                    self.isAboveThreshold = false // Reset when below threshold
                }

                print("Data collected: \(self.dataLog.count) samples, Accel Mag: \(aMag)")
            }
        } else {
            print("🚨 Accelerometer is NOT available on this device! 🚨")
        }
    }

    func stopRecording() {
        motionManager.stopAccelerometerUpdates()
        timer?.invalidate()

        if let startTime = dataLog.first?.timestamp, let endTime = dataLog.last?.timestamp {
            let duration = endTime - startTime // Time in seconds
            let durationMinutes = duration / 60.0 // Convert to minutes

            let compressionsPerMinute = durationMinutes > 0 ? Double(peakCount) / durationMinutes : 0.0

            print("🚀 Data collection stopped.")
            print("Total samples collected: \(dataLog.count)")
            print("⏱️ Total duration: \(String(format: "%.2f", duration)) seconds")
            print("📈 Total peaks detected: \(peakCount)")
            print("💓 Compressions per minute (CPM): \(String(format: "%.2f", compressionsPerMinute))")
        } else {
            print("⚠️ No data collected or invalid timestamps.")
        }
    }

    func exportCSV() {
        print("Exporting CSV...")

        if dataLog.isEmpty {
            print("No data collected. CSV file will not be created.")
            return
        }

        let filename = "motion_data.csv"
        let fileManager = FileManager.default
        let tempDir = fileManager.temporaryDirectory
        let fileURL = tempDir.appendingPathComponent(filename)

        var csvString = "Timestamp,Accel_X,Accel_Y,Accel_Z,Accel_Mag\n"
        for entry in dataLog {
            csvString.append("\(entry.timestamp),\(entry.ax),\(entry.ay),\(entry.az),\(entry.aMag)\n")
        }

        do {
            try csvString.write(to: fileURL, atomically: true, encoding: .utf8)
            print("CSV file saved at: \(fileURL)")
            print("Total samples written: \(dataLog.count)")
        } catch {
            print("Error writing CSV file: \(error)")
        }
    }
}
