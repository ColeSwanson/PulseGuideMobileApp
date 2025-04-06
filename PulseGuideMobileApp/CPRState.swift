//
//  CPRState.swift
//  PulseGuideMobileApp
//
//  Created by Matt McDonnell on 4/6/25.
//

import SwiftUI

public enum CPRState: String {
    case compressions = "Compressions"
    case breaths = "Breaths"
    case aed = "AED"
    case switchBuddy = "Switch"
    
    
    func getColor() -> Color {
        switch self {
            case .compressions:
                return .red
            case .breaths:
                return .cyan
            case .aed:
                return .yellow
            case .switchBuddy:
                return .purple
        }
    }
}
