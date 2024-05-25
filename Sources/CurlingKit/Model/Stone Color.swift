//
//  Stone Color.swift
//
//
//  Created by Nick Baughan on 04/05/2024.
//

import SwiftUI

public enum StoneColor: Int, Codable, Hashable, CaseIterable, Identifiable {
    case yellow, red, blue, white, green
    
    public var id: Int { rawValue }
    
    public var title: String {
        switch self {
        case .yellow:
            String(localized: "Yellow", bundle: .module)
        case .red:
            String(localized: "Red", bundle: .module)
        case .blue:
            String(localized: "Blue", bundle: .module)
        case .white:
            String(localized: "White", bundle: .module)
        case .green:
            String(localized: "Green", bundle: .module)
        }
    }
    
    public var color: Color {
        switch self {
        case .yellow: .yellow
        case .red: .red
        case .blue: .blue
        case .white: .white
        case .green: .green
        }
    }
    
    public var complementaryStoneColor: Self {
        switch self {
        case .yellow: .red
        case .red: .yellow
        case .blue: .white
        case .white: .blue
        case .green: .white
        }
    }
}
