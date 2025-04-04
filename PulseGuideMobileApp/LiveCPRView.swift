//
//  LiveCPRView.swift
//  PulseGuideMobileApp
//
//  Created by Matt McDonnell on 4/3/25.
//

import SwiftUI
import Combine


struct LiveCPRView: View {
    @Binding var isPresented: Bool
    @State private var showEndAlert = false
    
    @State private var compressionCounter = 1
    
    @State private var status: Status = .good
    @State private var backgroundColor: Color = .red
    
    @State private var elapsedTime = 0 // total seconds
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    private let audioCounter = AudioCounter()
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack {
                
                HStack(spacing: 2) {
                    Image(systemName: "clock")
                        .fontWeight(.medium)
                        .padding(.trailing, 2)
                    
                    Text("\(elapsedTime / 60)")
                        .contentTransition(.numericText())
                        .animation(.easeInOut, value: elapsedTime / 60)
                    
                    Text(":")
                        .fontWeight(.medium)
                    
                    Text(String(format: "%02d", elapsedTime % 60))
                        .contentTransition(.numericText())
                        .animation(.easeInOut, value: elapsedTime % 60)
                    
                    Spacer()
                }
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .onReceive(timer) { _ in
                    elapsedTime += 1
                }
                
                Spacer()
                
                Text("Compressions: \(compressionCounter - 1)")
                    .font(.largeTitle)
                
            }
            .padding(.horizontal)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("End") {
                    showEndAlert = true
                }
                .tint(.red)
                .buttonStyle(.borderedProminent)
            }
        }
        .alert("End CPR Session?", isPresented: $showEndAlert) {
            Button("End", role: .destructive) {
                isPresented = false
            }
            Button("Cancel", role: .cancel) { }
            
        } message: {
            Text("Are you sure you want to end this session?")
        }
    }
    
    private func startSpeaking() {
        SpeechManager.shared.speak("Hello there")
    }
    
    private func updateStatus() {
        let num = Int.random(in: 0...3)
        let colors: [Color] = [.red, .yellow, .green, .cyan]
        backgroundColor = colors[num]
    }
    
    private func formattedElapsedTime(from seconds: Int) -> String {
        if seconds < 60 {
            return "\(seconds) SEC"
        } else {
            let minutes = seconds / 60
            let remainingSeconds = seconds % 60
            
            if remainingSeconds == 0 {
                return "\(minutes) MIN"
            } else {
                return "\(minutes) MIN" + " \(remainingSeconds) SEC"
            }
        }
    }

}

#Preview {
    LiveCPRView(isPresented: .constant(true))
}
