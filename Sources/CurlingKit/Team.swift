import SwiftData

@Model
public final class Team {
    var name: String
    
    var players: [Player]
    
    init(name: String, players: [Player] = []) {
        self.name = name
        self.players = players
    }
}


@Model
final class Player {
    
    /// The name of the player.
    var name: String
    
    /// The teams which the player is part of.
    var teams: [Team]
    
    /// Whether a player is left- or right-handed
    var handedness: Handedness?
    
    init(name: String, teams: [Team]) {
        self.name = name
        self.teams = teams
    }
}

enum Handedness: Codable {
    case rightHanded, leftHanded
}
