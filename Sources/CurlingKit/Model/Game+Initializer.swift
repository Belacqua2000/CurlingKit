//
//  Game+Initializer.swift
//  CurlingKit
//
//  Created by Nick Baughan on 24/10/2024.
//

import Foundation
import SwiftData

public extension Game {
    static func from(stableIdentifier: UUID, modelContext: ModelContext) throws -> Game {
        let descriptor = FetchDescriptor<Game>(predicate: #Predicate { $0.stableIdentifier == stableIdentifier} )
        let games = try modelContext.fetch(descriptor)
        if let game = games.first {
            return game
        } else {
            throw CurlingKitError.gameNotFound(stableIdentifier: stableIdentifier)
        }
    }
}

enum CurlingKitError: Error {
    case gameNotFound(stableIdentifier: UUID)
}
