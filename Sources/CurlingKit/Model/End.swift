import SwiftData
import Foundation

/// A subunit of a game.
@Model
public final class End {
    // MARK: - SwiftData Properties
    /// The game which the end belongs to.
    @Relationship
    public var game: Game?
    
    /// The index of the end.
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
        guard let game else { return .own }
        if let previousEnd = game.ends?.sorted(using: SortDescriptor(\.number)).last(where: { $0.number < number }) {
            
            return switch previousEnd.scoringTeam {
            case .own: .opposition
            case .opposition: .own
            case nil: previousEnd.teamWithHammer
            }
            
        } else {
            return game.teamWithHammer
        }
    }
    
    /// Whether the scoring team is not the team with the hammer.
    ///
    /// See ``scoringTeam`` and ``teamWithHammer``.
    public var steal: Bool {
        scoringTeam != teamWithHammer
    }
    
    public init(number: Int) {
        self.number = number
    }
    
    public func switchTeams() {
        scoringTeam?.toggle()
    }
}
