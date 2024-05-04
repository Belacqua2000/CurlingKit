//
//  Stone Color.swift
//
//
//  Created by Nick Baughan on 04/05/2024.
//

import SwiftUI

public enum StoneColor: Codable, Hashable, CaseIterable {
    case yellow, red, blue, white
    
    public var title: String {
        switch self {
        case .yellow:
            "Yellow"
        case .red:
            "Red"
        case .blue:
            "Blue"
        case .white:
            "White"
        }
    }
    
    public var color: Color {
        switch self {
        case .yellow: .yellow
        case .red: .red
        case .blue: .blue
        case .white: .white
        }
    }
}
