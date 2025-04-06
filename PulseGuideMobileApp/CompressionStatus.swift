//
//  CompressionStatus.swift
//  PulseGuideMobileApp
//
//  Created by Matt McDonnell on 4/3/25.
//

import SwiftUI

public enum CompressionStatus: String {
    case good = "Good"
    case caution = "Caution"
    case bad = "Bad"
    case intermediate = "Intermediate"
    
    func getColor() -> Color {
        switch self {
            case .good:
                return .green
            case .caution:
                return .yellow
            case .bad:
                return .red
            case .intermediate:
                return .cyan
        }
    }
}
