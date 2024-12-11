//
//  Position.swift
//  
//
//  Created by Nick Baughan on 04/05/2024.
//

import Foundation
import Charts

/// The position in a curling team.
public enum Position: Int, Codable, CaseIterable, Identifiable, Comparable, Sendable, Plottable {
    
    /// Sorts two positions by order of typical play.
    ///
    /// Lead, second, third, then skip.
    public static func < (lhs: Position, rhs: Position) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
    
    case lead = 1, second, third, skip
    
    /// The localized title of the position.
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
    
    public var primitivePlottable: String {
        title
    }
    
    public init?(primitivePlottable: String) {
        guard let value = Self.allCases.first(where: { $0.title == primitivePlottable }) else { return nil }
        self = value
    }
    
    public var id: Int { rawValue }
}
