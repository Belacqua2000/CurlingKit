//
//  Position.swift
//  
//
//  Created by Nick Baughan on 04/05/2024.
//

import Foundation

/// The position in a curling team.
public enum Position: Int, Codable, CaseIterable, Identifiable {
    case lead = 1, second, third, skip
    
    public var title: String {
        switch self {
        case .lead:
            String(localized: "Lead", bundle: .module, comment: "The team position.")
        case .second:
            String(localized: "Second", bundle: .module, comment: "The team position.")
        case .third:
            String(localized: "Third", bundle: .module, comment: "The team position.")
        case .skip:
            String(localized: "Skip", bundle: .module, comment: "The team position.")
        }
    }
    
    /// The stones which are typically played by the position.
    public var recommendedStones: Set<Int> {
        switch self {
        case .lead:
            [1,2]
        case .second:
            [3,4]
        case .third:
            [5,6]
        case .skip:
            [7,8]
        }
    }
    
    public var id: Int { rawValue }
}
