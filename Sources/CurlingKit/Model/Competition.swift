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
    @Attribute(.allowsCloudEncryption)
    public var title: String
    
    /// The games you have played in this competition.
    @Relationship(inverse: \Game.competition)
    public var games: Array<Game>? = []
    
    /// The rules associated with this competition.
//    public var configuration: GameConfiguration?
    
    public init(title: String) {
        self.title = title.isEmpty ? String(localized: "Untitled Competition", bundle: .module, comment: "Default competition title.") : title
//        self.configuration = configuration
    }
}
