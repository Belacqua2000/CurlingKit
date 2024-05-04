import SwiftData

@Model
public final class Team {
    public var name: String
    
    public var players: [Player]
    
    public init(name: String, players: [Player] = []) {
        self.name = name
        self.players = players
    }
}


@Model
public final class Player {
    
    /// The name of the player.
    public var name: String
    
    /// The teams which the player is part of.
    public var teams: [Team]
    
    /// Whether a player is left- or right-handed
    public var handedness: Handedness?
    
    public init(name: String, teams: [Team]) {
        self.name = name
        self.teams = teams
    }
}

public enum Handedness: Codable {
    case rightHanded, leftHanded
}
