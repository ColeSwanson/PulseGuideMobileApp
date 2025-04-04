//
//  AudioCounter.swift
//  PulseGuideMobileApp
//
//  Created by Matt McDonnell on 4/3/25.
//

import Foundation
import AVFoundation

class AudioCounter {
    private var audioPlayer: AVAudioPlayer?
    private var count = 1
    private var timer: Timer?
    
    // Start the 1 to 30 counting sequence, one number per second
    public func startCounting() {
        count = 1
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            if self.count <= 30 {
                self.playNumber(self.count)
                self.count += 1
            } else {
                self.timer?.invalidate()
                self.timer = nil
            }
        }
    }
    
    // Play a number audio file (e.g., "01.mp3", "02.mp3")
    private func playNumber(_ number: Int, completion: (() -> Void)? = nil) {
        let fileName = String(format: "%02d", number)
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "mp3") else {
            print("Missing file: \(fileName).mp3")
            completion?()
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + (audioPlayer?.duration ?? 1.0)) {
                completion?()
            }
        } catch {
            print("Error playing \(fileName).mp3: \(error)")
            completion?()
        }
    }
}

