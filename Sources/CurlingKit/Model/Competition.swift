//
//  Competition.swift
//
//
//  Created by Nick Baughan on 03/05/2024.
//

import SwiftData


@Model
public final class Competition {
    
    /// The name of the competition.
    public var title: String
    
    /// The games you have played in this competition.
    @Relationship(inverse: \Game.competition)
    public var games: Array<Game>? = []
    
    /// The rules associated with this competition.
    public var configuration: GameConfiguration
    
    public init(title: String, configuration: GameConfiguration) {
        self.title = title
        self.configuration = configuration
    }
}
