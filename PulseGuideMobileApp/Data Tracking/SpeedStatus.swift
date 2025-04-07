//
//  SpeedStatus.swift
//  PulseGuideMobileApp
//
//  Created by Matt McDonnell on 4/6/25.
//

import SwiftUI

public enum SpeedStatus {
    case wayTooSlow
    case tooSlow
    case good
    case tooFast
    case wayTooFast
    
    public func getColor() -> Color {
        switch self {
            case .wayTooSlow, .wayTooFast:
                return .red
            case .tooSlow, .tooFast:
                return .orange
            case .good:
                return .green
        }
    }
}
