//
//  Competition.swift
//
//
//  Created by Nick Baughan on 03/05/2024.
//

import SwiftData
import Foundation

@Model
public final class Competition {
    @Attribute(.allowsCloudEncryption, .preserveValueOnDeletion)
    public var stableIdentifier: UUID = UUID()
    
    /// The name of the competition.
    @Attribute(.allowsCloudEncryption)
    public var title: String = "Untitled Competition"
    
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
