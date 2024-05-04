import SwiftData

/// A subunit of a game.
@Model
public final class End {
    // MARK: - SwiftData Properties
    /// The game which the end belongs to.
    public var game: Game
    
    /// The index of the game.
    ///
    /// This is typically between 1 and 8.
    public var number: Int = 0
    
    /// The stones which were played during the game.
    public var stones: [Stone] = []
    
    /// Whether this end has been played.
    public var played: Bool = true
    
    public var score: Int = 0
    public var scoringTeam: Game.RelativeTeam?
    
    
    // MARK: - Computed Properties
    public var blanked: Bool { score == 0 }
    
    /// Which team has the last stone.
    public var teamWithHammer: Game.RelativeTeam {
        if let previousEnd = game.ends.last(where: { $0.number < number }) {
            
            return switch previousEnd.scoringTeam {
            case .own: .opposition
            case .opposition: .own
            case nil: previousEnd.teamWithHammer
            }
            
        } else {
            return game.teamWithHammer
        }
    }
    
    public init(game: Game, number: Int) {
        self.game = game
        self.number = number
    }
}
