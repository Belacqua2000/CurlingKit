//
//  File.swift
//  
//
//  Created by Nick Baughan on 19/07/2024.
//

import SwiftData
import Foundation

@MainActor
public let previewContainer: ModelContainer = {
    do {
        let container = try ModelContainer(
            for: Game.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        let context = container.mainContext
        // Create competitions
        var competitionNames = [
            "2026 Winter Olympics",
            "Rankine Cup",
            "Poole Trophy",
            "Lomond League",
            "Gallowhill Ploughshare",
            "Saturday Super-League",
            "Rankine Cup",
            "Scottish Universities 2024"
        ]
        
        let opponents = [
            "Paul Baughan",
            "Nick Baughan",
            "Gill Baughan",
            "Hannah Baughan",
            "Eleanor Baughan",
            "Iain Cormack",
            "Julia Cormack",
            "Ross Cormack",
            "Ben Cormack",
            "Harry Cormack",
            "George Skea",
            "Joe Bloggs",
            "John Doe",
        ]
        
        competitionNames.forEach {
            let competition = Competition(title: $0)
            context.insert(competition)
        }
        
        let currentCompetitions = try context.fetch(FetchDescriptor<Competition>())
        
        for _ in 0..<10 {
            // Seconds in a year
            let randomSeconds = Int.random(in: -(31_536_000 * 2) ..< 0)
            
            // Random date in the past year
            let randomDate = Date.now.addingTimeInterval(TimeInterval(randomSeconds))
            
            // Create game
            let game = Game(on: randomDate, against: opponents.randomElement() ?? "")
            context.insert(game)
            
            game.position = Position.allCases.randomElement() ?? .skip
            game.competition = currentCompetitions.randomElement()
            
            game.setScoreCalculation(to: .ends, using: context)
            
            for end in game.ends ?? [] {
                end.score = Int.random(in: 0..<3)
                if end.score != 0 {
                    end.scoringTeam = [RelativeTeam.own, RelativeTeam.opposition].randomElement() ?? .own
                }
            }
            game.updateScoresFromEnds()
        }
        
        return container
    } catch {
        fatalError("Failed to create container.")
    }
}()

@MainActor
public let previewGame: Game = {
    try! previewContainer.mainContext.fetch(FetchDescriptor<Game>()).first!
}()

@MainActor
extension Game {
    static let preview = try! previewContainer.mainContext.fetch(FetchDescriptor<Game>()).first!
    static let previewUnplayed: Game = {
        let game = Game(on: .now, against: "")
        game.position = .skip
        previewContainer.mainContext.insert(game)
        return game
    }()
}

@MainActor
let previewEnd: End = {
    try! previewContainer.mainContext.fetch(FetchDescriptor<Game>()).first!.ends!.first!
}()

//@MainActor
//let previewStone: Stone = {
//    try! previewContainer.mainContext.fetch(FetchDescriptor<Stone>()).first!
//}()
