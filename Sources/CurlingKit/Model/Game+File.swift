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
        public static let fileExtension: String = "curlinggame"
        
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
        
        /// The final score of the game of the user's team.
        public var ownScore: Int
        
        /// The final score of the game of the opposition team.
        public var oppositionScore: Int
        
        public private(set) var scoreCalculation = Game.ScoreCalculationMode.ends
        
        public init(from model: Game) {
            title = model.title
            date = model.date
            notes = model.notes
            ends = model.ends?.compactMap { EndFile.Version1(from: $0) } ?? []
            scoreCalculation = model.scoreCalculation
            ownScore = model.ownScore
            oppositionScore = model.oppositionScore
        }
        
        public func modelFromFile(using context: ModelContext) -> Game {
            let newGame = Game(on: date)
            newGame.title = title
            newGame.notes = notes
            newGame.opponent = opponent
            newGame.ownScore = ownScore
            newGame.oppositionScore = oppositionScore
            context.insert(newGame)
            newGame.setScoreCalculation(to: scoreCalculation, using: context)
            newGame.ends = ends.map { $0.modelFromFile(using: context) }
            if newGame.scoreCalculation == .ends {
                newGame.updateScoresFromEnds()
            }
            return newGame
        }
    }
}
