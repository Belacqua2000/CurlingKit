//
//  File.swift
//  
//
//  Created by Nick Baughan on 09/05/2024.
//

import Foundation
import SwiftData

internal protocol ExportVersion: Codable {
    associatedtype Model: PersistentModel
    static var version: Int { get }
    
    func modelFromFile(using context: ModelContext) -> Model
    
    init?(from model: Model)
}

struct GameFile {
    
    struct Version1: ExportVersion {
        static var version: Int = 1
        
        /// A user-configurable title given to the game.
        public var title: String
        
        /// Additional notes written about the game.
        public var notes: String
        
        /// The start date when the game took place.
        public var date: Date
        
        /// The opposition team.
        public var opponent = String()
        
        /// Ends
        public var ends = [EndFile.Version1]()
        
        init?(from model: Game) {
            title = model.title
            date = model.date
            notes = model.notes
            ends = model.ends?.compactMap { EndFile.Version1(from: $0) } ?? []
        }
        
        func modelFromFile(using context: ModelContext) -> Game {
            let newGame = Game(on: date)
            newGame.notes = notes
            newGame.opponent = opponent
            context.insert(newGame)
            newGame.ends = ends.map { $0.modelFromFile(using: context) }
            return newGame
        }
    }
}
