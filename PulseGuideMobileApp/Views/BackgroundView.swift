//
//  BackgroundView.swift
//  PulseGuideMobileApp
//
//  Created by Matt McDonnell on 4/3/25.
//

import SwiftUI

struct BackgroundView: View {
    var color: Color = .red
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.black)
            
            Rectangle()
                .fill(Gradient(colors: [color.opacity(0.6), color.opacity(0.1)]))
        }
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    BackgroundView()
}
