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
        
        var title: String
        
        /// Additional notes written about the game.
        var notes: String
        
        /// The start date when the game took place.
        var date: Date
        
        /// The opposition team.
        var opponent: String
        
        /// Ends
        var ends: [EndFile.Version1]
        
        /// The final score of the game of the user's team.
        public var ownScore: Int
        
        /// The final score of the game of the opposition team.
        public var oppositionScore: Int
        
        /// The winner of the tiebreaker.
        public var tiebreakerWinner: RelativeTeam?
        
        /// Whether you start with the hammer.
        public var teamWithHammer: RelativeTeam
        
        /// The color of stones the player's own team are delivering.
        public var ownTeamStoneColor: StoneColor
        
        /// The color of stones the opposition team are delivering.
        public var oppositionTeamStoneColor: StoneColor
        
        public var position: Position
        
        public private(set) var scoreCalculation: Game.ScoreCalculationMode
        
        public init(from model: Game) {
            title = model.exportTitle
            opponent = model.opponent
            date = model.date
            notes = model.notes
            ends = model.ends?.compactMap { EndFile.Version1(from: $0) } ?? []
            scoreCalculation = model.scoreCalculation
            ownScore = model.ownScore
            teamWithHammer = model.teamWithHammer
            oppositionScore = model.oppositionScore
            position = model.position
            ownTeamStoneColor = model.ownTeamStoneColor
            oppositionTeamStoneColor = model.oppositionTeamStoneColor
        }
        
        public func modelFromFile(using context: ModelContext) -> Game {
            let newGame = Game(on: date, against: opponent)
            newGame.title = title
            newGame.notes = notes
            newGame.teamWithHammer = teamWithHammer
            newGame.ownScore = ownScore
            newGame.oppositionScore = oppositionScore
            newGame.position = position
            newGame.ownTeamStoneColor = ownTeamStoneColor
            newGame.oppositionTeamStoneColor = oppositionTeamStoneColor
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
