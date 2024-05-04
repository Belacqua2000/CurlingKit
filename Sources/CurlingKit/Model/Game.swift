import SwiftData
import SwiftUI

/// A curling match between two teams.
@Model
public final class Game {
    // MARK: - Details
    
    /// A user-configurable title given to the game.
    public var title: String = "Untitled Game"
    
    /// Additional notes written about the game.
    public var notes = String()
    
    /// The start date when the game took place.
    public var date: Date
    
    /// The rink which the game was played in.
    public var location: IceRink?
    
    // MARK: - Configuration
    
    /// The opposition team.
    public var opponent: Team?
    
    /// The competition this game is part of.
    public var competition: Competition?
    
    /// The rating given to the rink during this game.
    public var iceRating: IceRating?
    
    /// The configuration of the game.
    public var configuration: GameConfiguration = GameConfiguration.standard8Ends
    
    /// Whether you start with the hammer.
    public var teamWithHammer: RelativeTeam = RelativeTeam.own
    
    /// The color of stones the player's own team are delivering..
    public var ownTeamStoneColor: StoneColor?
    
    /// The color of stones the opposition team are delivering..
    public var oppositionTeamStoneColor: StoneColor?
    
    /// The ends of this game.
    @Relationship(deleteRule: .cascade, inverse: \End.game)
    public var ends: [End]? = []
    
    /// Additional points added to the team.
    public var penaltyPoints: Int = 0
    
    // MARK: - Outcomes
    
    /// The outcome of a game.
    public enum Outcome: Codable {
        case lose, win, peel
        public var title: String {
            switch self {
            case .lose:
                "Lose"
            case .win:
                "Win"
            case .peel:
                "Peel"
            }
        }
    }
    
    public var ownScore: Int {
        ends?
            .filter { $0.scoringTeam == .own }
            .map { $0.score }
            .reduce(0, +)
        ?? 0
    }
    
    public var oppositionScore: Int {
        ends?
            .filter { $0.scoringTeam == .opposition }
            .map { $0.score }
            .reduce(0, +)
        ?? 0
    }
    
    /// The outcome of the game.
    public var outcome: Outcome? {
        if ownScore == oppositionScore {
            return .peel
        } else if ownScore < oppositionScore {
            return .lose
        } else {
            return .win
        }
    }
    
    public init(
        on date: Date,
        against opponent: Team? = nil
    ) {
        self.date = date
        self.opponent = opponent
    }
    
    /// Add another end to this game.
    public func addEnd(using context: ModelContext) {
        if ends == nil {
            ends = []
        }
        let end = End(number: (ends?.count ?? 0) + 1)
        end.game = self
        context.insert(end)
    }
    
    public func adjustEndsFromConfiguration(using context: ModelContext) {
        withAnimation {
            while ends?.count ?? 0 < configuration.numberOfEnds {
                addEnd(using: context)
            }
            
            while ends?.count ?? 0 > configuration.numberOfEnds {
                if let lastEnd = ends?.sorted(using: SortDescriptor(\.number)).last {
                    context.delete(lastEnd)
                }
            }
        }
    }
    
    public enum RelativeTeam: Codable {
        /// The user's own team.
        case own
        
        /// The team which the user is playing.
        case opposition
        
        public var title: String {
            switch self {
            case .own:
                "Own Team"
            case .opposition:
                "Opposition"
            }
        }
    }
    
    /// Calculate the number of ends which match the given statistic.
    /// - Parameter endStatistic: The statistic you are calculating.
    /// - Returns: The proportion of ends which meet the statistic.  This number is between 0–1.
    public func valueFor(_ endStatistic: EndEfficiency) -> Double? {
        let qualifyingEnds = ends?.filter(endStatistic.qualifiesForStatistic) ?? []
        guard qualifyingEnds.count > 1 else { return nil }
        return Double(qualifyingEnds.filter(endStatistic.statisticMet).count) / Double(qualifyingEnds.count)
    }
}
