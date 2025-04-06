//
//  DepthStatus.swift
//  PulseGuideMobileApp
//
//  Created by Matt McDonnell on 4/6/25.
//

import SwiftUI

public enum DepthStatus {
    case wayTooShallow
    case tooShallow
    case good
    case tooDeep
    case wayTooDeep
    
    public func getColor() -> Color {
        switch self {
            case .wayTooShallow, .wayTooDeep:
                return .red
            case .tooShallow, .tooDeep:
                return .orange
            case .good:
                return .green
        }
    }
}
