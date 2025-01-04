//
//  RelativeTeam.swift
//
//
//  Created by Nick Baughan on 25/05/2024.
//

import Foundation
import Charts

public enum RelativeTeam: Codable, Sendable, CaseIterable, Plottable {
    /// The user's own team.
    case own
    
    /// The team which the user is playing.
    case opposition
    
    public var title: String {
        switch self {
        case .own:
            String(localized: "Own Team", bundle: .module)
        case .opposition:
            String(localized: "Opposition", bundle: .module)
        }
    }
    
    mutating func toggle() {
        self = switch self {
        case .own: .opposition
        case .opposition: .own
        }
    }
    
    public var primitivePlottable: String {
        title
    }
    
    public init?(primitivePlottable: String) {
        guard let value = Self.allCases.first(where: { $0.title == primitivePlottable }) else { return nil }
        self = value
    }
    
    public static let allCases: [RelativeTeam] = [.own, .opposition]
}
