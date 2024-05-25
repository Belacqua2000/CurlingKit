//
//  RelativeTeam.swift
//
//
//  Created by Nick Baughan on 25/05/2024.
//

import Foundation

public enum RelativeTeam: Codable {
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
}
