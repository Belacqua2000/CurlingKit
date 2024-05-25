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
    public var number: Int = 1
    
    /// The stones which were played during the game.
    public var stones: [Stone] = []
    
    /// Whether this end has been played.
    public var played: Bool = true
    
    /// The score of the current end.
    ///
    /// The scoring team is stored in ``scoringTeam``.
    /// This value is 0 if the end has been blanked.
    public var score: Int = 0
    
    /// The team which scored.
    ///
    /// The score from the team can be determined using ``score``.
    /// This value is `nil` if the end is blanked.
    public var scoringTeam: Game.RelativeTeam?
    
    
    // MARK: - Computed Properties
    public var blanked: Bool { score == 0 }
    
    /// Which team has the last stone.
    ///
    /// This is automatically determined by the scoring team of the preceding end.  If no preceding end exists (i.e., this is the first end), this is determined by the team which was mannually allocated with hammer for the beginning of the game.  See ``/CurlingKit/Game/teamWithHammer``.
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
    
    /// A steal occurs when the end is scored by the team without the hammer.
    ///
    /// See ``scoringTeam`` and ``teamWithHammer``.
    public var steal: Bool {
        scoringTeam != teamWithHammer
    }
    
    /// A force occurs when the team with the hammer scores a 1.
    ///
    /// See ``scoringTeam``, ``teamWithHammer``, and ``score``.
    public var forced: Bool {
        scoringTeam == teamWithHammer && score == 1
    }
    
    public init(number: Int) {
        self.number = number
    }
    
    public func switchTeams() {
        scoringTeam?.toggle()
    }
}
