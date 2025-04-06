//
//  DialGaugeView.swift
//  PulseGuideMobileApp
//
//  Created by Matt McDonnell on 4/6/25.
//

import SwiftUI

struct SpeedometerGaugeStyle: GaugeStyle {
    private let gradientStops: [Color] = [.red, .red, .green, .green, .red, .red]
    
    private var speedGradient = AngularGradient(colors: [.red, .red, .green, .green, .red, .red], center: .center, angle: Angle(degrees: -45))
        
    func makeBody(configuration: Configuration) -> some View {
        let progress = min(max(configuration.value, 0), 1)
        let currentColor = colorAtProgress(progress, gradient: gradientStops)
        
        ZStack {
            
            Circle()
                .foregroundColor(Color(.black.opacity(0.5)))
            
            Circle()
                .trim(from: 0, to: 0.75 * configuration.value)
                .stroke(speedGradient, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                .rotationEffect(.degrees(135))
            
            Circle()
                .trim(from: 0, to: 0.75)
                .stroke(Color.black, style: StrokeStyle(lineWidth: 10, lineCap: .butt, lineJoin: .round, dash: [1, 38], dashPhase: 0.0))
                .rotationEffect(.degrees(135))
            
            VStack {
                configuration.currentValueLabel
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundColor(currentColor)
                
                Text("CPM")
                    .font(.system(.body, design: .rounded))
                    .bold()
                    .foregroundColor(.gray)
            }
        }
    }
    
    private func colorAtProgress(_ progress: Double, gradient: [Color]) -> Color {
        let clamped = min(max(progress, 0), 1)
        let segmentCount = gradient.count - 1
        let scaledProgress = clamped * Double(segmentCount)
        let lowerIndex = Int(scaledProgress)
        let upperIndex = min(lowerIndex + 1, segmentCount)
        let t = scaledProgress - Double(lowerIndex)
        
        let lowerColor = UIColor(gradient[lowerIndex])
        let upperColor = UIColor(gradient[upperIndex])
        
        var r1: CGFloat = 0, g1: CGFloat = 0, b1: CGFloat = 0, a1: CGFloat = 0
        var r2: CGFloat = 0, g2: CGFloat = 0, b2: CGFloat = 0, a2: CGFloat = 0
        
        lowerColor.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        upperColor.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        
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
