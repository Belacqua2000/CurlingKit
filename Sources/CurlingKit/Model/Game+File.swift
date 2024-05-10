//
//  File.swift
//  
//
//  Created by Nick Baughan on 09/05/2024.
//

import Foundation
import SwiftData

public struct GameFile {
    
    public struct Version1: ExportVersion {
        public static var fileExtension: String = "curlinggame"
        
        public var fileName: String {
            title
        }
        
        public static var version: Int = 1
        
        /// A user-configurable title given to the game.
        var title: String
        
        /// Additional notes written about the game.
        var notes: String
        
        /// The start date when the game took place.
        var date: Date
        
        /// The opposition team.
        var opponent = String()
        
        /// Ends
        var ends = [EndFile.Version1]()
        
        public init?(from model: Game) {
            title = model.title
            date = model.date
            notes = model.notes
            ends = model.ends?.compactMap { EndFile.Version1(from: $0) } ?? []
        }
        
        public func modelFromFile(using context: ModelContext) -> Game {
            let newGame = Game(on: date)
            newGame.notes = notes
            newGame.opponent = opponent
            context.insert(newGame)
            newGame.ends = ends.map { $0.modelFromFile(using: context) }
            return newGame
        }
    }
}
