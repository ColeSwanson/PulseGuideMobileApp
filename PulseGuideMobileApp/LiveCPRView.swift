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
    @State private var muted = false
    
    @State private var compressionSpeed = 100.0
    @State private var compressionDepth: Double = 2.20

    let minDepth: Double = 1.5
    let maxDepth: Double = 3.0
    
    @State private var compressionCounter = 22
    @State private var compressionRound = 1
    
    @State private var overallStatus: CompressionStatus = .good
    @State private var depthStatus: DepthStatus = .good
    @State private var speedStatus: SpeedStatus = .good
    @State private var backgroundColor: Color = .red
    
    @State private var elapsedTime = 0 // total seconds
    
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    private let speedGaugeColors = Gradient(colors: [.red, .green, .green, .red])
    private let audioCounter = AudioCounter()
    
    var body: some View {
        ZStack {
            BackgroundView(color: .green)
            
            VStack {
                
                // Live Mode
                HStack {
                    VStack {
                        HStack {
                            Image(systemName: "bolt.heart.fill")
                                .font(.system(size: 24))
                                .foregroundStyle(.red)
                            
                            Text("LIVE MODE OFF")
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .foregroundStyle(.white)
                            
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 1)
                        
                        HStack {
                            Text("Turn on to use Apple Watch for live feedback.")
                                .foregroundStyle(.white)
                                .font(.system(size: 14))
                                .multilineTextAlignment(.leading)
                            
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical)
                    
                    Button {
                        print("tapped call")
                    } label: {
                        Text("Turn On")
                            .fontWeight(.medium)
                    }
                    .tint(.green)
                    .buttonStyle(.borderedProminent)
                    .padding(.horizontal)
                }
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundStyle(.black.opacity(0.3))
                )
                
                // Speed
                HStack {
                    Gauge(value: compressionSpeed, in: 80...140) {
                        Text("CPM")
                    } currentValueLabel: {
                        Text("\(Int(compressionSpeed))")
                    }
                    .gaugeStyle(SpeedometerGaugeStyle())
                    .frame(width: 150, height: 150)
                    .padding()
                    
                    VStack(alignment: .leading) {
                        HStack {
                            getSpeedLabel()
                                .fontWeight(.bold)
                                .fontDesign(.rounded)
                                .foregroundStyle(.white)
                                .padding(5)
                                .background(
                                    RoundedRectangle(cornerRadius: 5)
                                        .foregroundStyle(speedStatus.getColor())
                                )
                            
                            Spacer()
                        }
                        
                        Text(getSpeedSubtext())
                            .multilineTextAlignment(.leading)
                            .lineLimit(.none)
                            .foregroundStyle(.white)
                            .padding(.trailing)
                        
                        Slider(value: $compressionSpeed, in: 80...140)
                            .onChange(of: compressionSpeed) { _,_ in
                                updateSpeedStatus()
                            }
                            .padding(.horizontal)
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundStyle(.black.opacity(0.3))
                )
                
                // Depth
                HStack {
                    DepthView(depth: $compressionDepth)
                        .offset(x: 30)
                    
                    VStack(alignment: .leading) {
                        HStack {
                            getDepthLabel()
                                .fontWeight(.bold)
                                .fontDesign(.rounded)
                                .foregroundStyle(.white)
                                .padding(5)
                                .background(
                                    RoundedRectangle(cornerRadius: 5)
                                        .foregroundStyle(depthStatus.getColor())
                                )
                            
                            Spacer()
                        }
                        
                        Text("\(compressionDepth.roundForString) IN")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundStyle(colorAtDepth(compressionDepth))
                        
                        Text(getDepthSubtext())
                            .multilineTextAlignment(.leading)
                            .foregroundStyle(.white)
                            .padding(.trailing)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Slider(value: $compressionDepth, in: minDepth...maxDepth)
                            .padding(.top)
                            .onChange(of: compressionDepth) { _, _ in
                                updateDepthStatus()
                            }
                            .padding(.horizontal)
                    }
                    
                    Spacer()
                }
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundStyle(.black.opacity(0.3))
                )
                
                GeometryReader { geo in
                    let sideLength = geo.size.width / 2
                    
                    HStack {
                        // Compression Counter
                        VStack {
                            Text("COMPRESSION #")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundStyle(.white)
                            
                            Spacer()
                            
                            Text("\(compressionCounter)")
                                .font(.system(size: 44, weight: .bold, design: .rounded))
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.cyan)
                            
                            Text("Round \(compressionRound)")
                                .font(.system(size: 18))
                                .foregroundStyle(.white)
                            
                            Spacer()
                        }
                        .padding()
                        .frame(height: sideLength)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .foregroundStyle(.black.opacity(0.3))
                        )
                        
                        // Next Up
                        VStack {
                            Text("NEXT UP")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundStyle(.white)
                            
                            Spacer()
                            
                            Text("GIVE BREATHS")
                                .font(.system(size: 30, weight: .bold, design: .rounded))
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.purple)
                            
                            Spacer()
                        }
                        .padding()
                        .frame(height: sideLength)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .foregroundStyle(.black.opacity(0.3))
                        )
                    }
                }
                .frame(height: 150)

                

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
            
            ToolbarItem(placement: .principal) {
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
                }
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .onReceive(timer) { _ in
                    elapsedTime += 1
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    muted.toggle()
                } label: {
                    Image(systemName: muted ? "speaker.wave.2.circle.fill" : "speaker.slash.circle.fill")
                        .font(.system(size: 32))
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(.white)
                }
                .contentTransition(
                    .symbolEffect(.replace)
                )
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
    
    private func updateSpeedStatus() {
        withAnimation {
            if compressionSpeed <= 90 {
                speedStatus = .wayTooSlow
            } else if compressionSpeed < 100 {
                speedStatus = .tooSlow
            } else if compressionSpeed <= 120 {
                speedStatus = .good
            } else if compressionSpeed < 130 {
                speedStatus = .tooFast
            } else {
                speedStatus = .wayTooFast
            }
        }
    }
    
    private func getSpeedSubtext() -> String {
        switch speedStatus {
            case .wayTooSlow:
                return "Compressions are not adequate. Switch out if you are tired."
            case .tooSlow:
                return "You're a bit behind tempo. Try to speed up!"
            case .good:
                return "You're keeping a strong pace. Keep it up!"
            case .tooFast:
                return "You're going a bit too fast. Stay in control."
            case .wayTooFast:
                return "You're going way too fast. "
        }
    }
    
    private func getDepthSubtext() -> String {
        switch depthStatus {
            case .wayTooShallow:
                return "You're too light. Switch out if you are tired."
            case .tooShallow:
                return "You're a bit light. Go deeper."
            case .good:
                return "Good depth. Keep it up!"
            case .tooDeep:
                return "You're going too deep. Lighten up."
            case .wayTooDeep:
                return "You're risking damage. Go lighter."
        }
    }
    
    private func getSpeedLabel() -> some View {
        switch speedStatus {
            case .wayTooSlow:
                return Label("SPEED UP", systemImage: "exclamationmark.octagon.fill")
            case .tooSlow:
                return Label("SPEED UP", systemImage: "exclamationmark.triangle.fill")
            case .good:
                return Label("GOOD SPEED", systemImage: "checkmark.circle.fill")
            case .tooFast:
                return Label("SLOW DOWN", systemImage: "exclamationmark.triangle.fill")
            case .wayTooFast:
                return Label("SLOW DOWN", systemImage: "exclamationmark.octagon.fill")
        }
    }
    
    private func getDepthLabel() -> some View {
        switch depthStatus {
            case .wayTooShallow:
                return Label("TOO SHALLOW", systemImage: "exclamationmark.octagon.fill")
            case .tooShallow:
                return Label("TOO SHALLOW", systemImage: "exclamationmark.triangle.fill")
            case .good:
                return Label("GOOD DEPTH", systemImage: "checkmark.circle.fill")
            case .tooDeep:
                return Label("TOO DEEP", systemImage: "exclamationmark.triangle.fill")
            case .wayTooDeep:
                return Label("TOO DEEP", systemImage: "exclamationmark.octagon.fill")
        }
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
    
    private func gradientColor(for value: Double) -> Color {
        let stops: [Color] = [.red, .orange, .green, .green, .orange, .red]
        let progress = min(max((value - minDepth) / (maxDepth - minDepth), 0), 1)
        
        let index = Int(progress * Double(stops.count - 1))
        return stops[index]
    }
    
    private func updateDepthStatus() {
        withAnimation {
            if compressionDepth < 1.6 {
                depthStatus = .wayTooShallow
            } else if compressionDepth < 2.00 {
                depthStatus = .tooShallow
            } else if compressionDepth <= 2.40 {
                depthStatus = .good
            } else if compressionDepth < 2.90 {
                depthStatus = .tooDeep
            } else {
                depthStatus = .wayTooDeep
            }
        }
    }
    
    private func colorAtDepth(_ depth: Double) -> Color {
        let stops: [Color] = [.red, .orange, .green, .orange, .red]
        let normalized = (depth - minDepth) / (maxDepth - minDepth)
        let clamped = min(max(normalized, 0), 1)
        
        let scaled = clamped * Double(stops.count - 1)
        let lowerIndex = Int(floor(scaled))
        let upperIndex = min(lowerIndex + 1, stops.count - 1)
        let t = scaled - Double(lowerIndex)
        
        let c1 = UIColor(stops[lowerIndex])
        let c2 = UIColor(stops[upperIndex])
        
        var r1: CGFloat = 0, g1: CGFloat = 0, b1: CGFloat = 0, a1: CGFloat = 0
        var r2: CGFloat = 0, g2: CGFloat = 0, b2: CGFloat = 0, a2: CGFloat = 0
        
        c1.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        c2.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        
        return Color(
            red: Double(r1 + (r2 - r1) * CGFloat(t)),
            green: Double(g1 + (g2 - g1) * CGFloat(t)),
            blue: Double(b1 + (b2 - b1) * CGFloat(t)),
            opacity: Double(a1 + (a2 - a1) * CGFloat(t))
        )
    }

}

#Preview {
    LiveCPRView(isPresented: .constant(true))
}
