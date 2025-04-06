//
//  DepthView.swift
//  PulseGuideMobileApp
//
//  Created by Matt McDonnell on 4/6/25.
//

import SwiftUI

struct DepthView: View {
    @Binding var depth: Double
    
    let minDepth: Double = 1.5
    let maxDepth: Double = 3.0
    let gaugeHeight: CGFloat = 200
    let gaugeWidth: CGFloat = 40
    
    var body: some View {
        
        VStack {
            HStack {
                GeometryReader { geo in
                    Gauge(value: depth, in: minDepth...maxDepth) {
                        Text("DEPTH")
                            .bold()
                            .fontDesign(.rounded)
                            .foregroundStyle(.white)
                    } currentValueLabel: {
                        EmptyView()
                    }
                    .gaugeStyle(.linearCapacity)
                    .tint(
                        LinearGradient(
                            gradient: Gradient(colors: [.red, .red, .green, .green, .red, .red]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: gaugeHeight, height: gaugeWidth) // flipped due to rotation
                    .rotationEffect(.degrees(-90))
                    .position(x: geo.size.width / 2, y: geo.size.height / 2)
                }
                .frame(width: gaugeWidth, height: gaugeHeight)

                
                VStack(alignment: .leading) {
                    Spacer()
                    Text("2.8")
                    Spacer()
                    Spacer()
                    Text("2.4")
                    Spacer()
                    Spacer()
                    Text("2.0")
                    Spacer()
                    Spacer()
                    Text("1.6")
                    Spacer()
                }
                .foregroundStyle(.gray)
                .frame(height: 200)
                .padding(.trailing)
                
                Spacer()

            }
        }
        .padding()
    }
}

#Preview {
    //DepthView(depth: .constant(2.25))
    
    LiveCPRView(isPresented: .constant(true))
}
