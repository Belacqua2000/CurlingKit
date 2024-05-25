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
    public var opponent = String()
    
    /// The competition this game is part of.
    public var competition: Competition?
    
    /// The rating given to the rink during this game.
    public var iceRating: IceRating?
    
    /// The configuration of the game.
    public var configuration: GameConfiguration = GameConfiguration.standard8Ends
    
    /// Whether you start with the hammer.
    public var teamWithHammer: RelativeTeam = RelativeTeam.own
    
    /// The color of stones the player's own team are delivering..
    public var ownTeamStoneColor: StoneColor = StoneColor.red
    
    /// The color of stones the opposition team are delivering..
    public var oppositionTeamStoneColor: StoneColor = StoneColor.yellow
    
    /// The ends of this game.
    @Relationship(deleteRule: .cascade, inverse: \End.game)
    public var ends: [End]? = []
    
    public var endCount: Int { ends?.count ?? 20}
    
    /// Additional points added to the team.
    public var penaltyPoints: Int = 0
    
    // MARK: - Outcomes
    
    /// The outcome of a game.
    public enum Outcome: Codable, Comparable {
        case lose, peel, win
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
    
    /// The final score of the game of the user's team.
    ///
    /// This can be entered manually if there are no ends, or can be calculated automatically using ``calculateScoresFromEnds()``
    public var ownScore: Int = 0
    
    /// The final score of the game of the opposition team.
    ///
    /// This can be entered manually if there are no ends, or can be calculated automatically using ``calculateScoresFromEnds()``
    public var oppositionScore: Int = 0
    
    /// Calculates the total score from ends.
    ///
    /// This sums the scores entered for all of the game's ends and updates ``ownScore`` and ``oppositionScore`` accordingly.
    public func calculateScoresFromEnds() {
        withAnimation {
            oppositionScore = ends?
                .filter { $0.scoringTeam == .opposition }
                .map { $0.score }
                .reduce(0, +)
            ?? 0
            
            ownScore = ends?
                .filter { $0.scoringTeam == .own }
                .map { $0.score }
                .reduce(0, +)
            ?? 0
        }
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
        against opponent: String = ""
    ) {
        self.date = date
        self.opponent = opponent
        
        title = Self.defaultTitle(for: date)
    }
    
    static func defaultTitle(for date: Date) -> String {
        let weekDay = date.formatted(.dateTime.weekday(.wide))
        let hour = Calendar.current.component(.hour, from: date)
        
        let timeOfDay = switch hour {
        case 0...11: "Morning"
        case 12...17: "Afternoon"
        case 18...23: "Evening"
        default: "Morning"
        }
        
        return [weekDay, timeOfDay, "Game"].joined(separator: " ")
    }
    
    private static let formatStyle = {
        let df = DateFormatter()
        df.doesRelativeDateFormatting = true
        df.timeStyle = .short
        df.dateStyle = .medium
        df.formattingContext = .beginningOfSentence
        return df
    }()
    
    public var formattedDate: String {
        if Calendar.current.isDateInToday(date) || Calendar.current.isDateInYesterday(date) {
            return Self.formatStyle.string(from: date)
        } else if let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: .now), sevenDaysAgo < date {
            return date.formatted(.dateTime.weekday(.wide).hour().minute())
        } else {
            return date.formatted(.dateTime.weekday(.abbreviated).day().month().year().hour().minute())
        }
    }
    
    public func dateChanged(oldDate: Date, newDate: Date) {
        if title == Self.defaultTitle(for: oldDate) {
            withAnimation {
                title = Self.defaultTitle(for: newDate)
            }
        }
    }
    
    /// Add another end to this game.
    public func addEnd(using context: ModelContext) {
        if ends == nil {
            ends = []
        }
        let end = End(number: (ends?.count ?? 0) + 1)
        end.game = self
        ends?.append(end)
        context.insert(end)
    }
    
    public func adjustEndsFromConfiguration(using context: ModelContext) {
        withAnimation {
            while ends?.count ?? 0 < configuration.numberOfEnds {
                addEnd(using: context)
//                try? context.save()
            }
            
            while ends?.count ?? 0 > configuration.numberOfEnds {
                if let lastEnd = ends?.sorted(using: SortDescriptor(\.number)).last {
                    ends?.removeAll { $0.id == lastEnd.id }
                    context.delete(lastEnd)
//                    try? context.save()
                }
            }
            calculateScoresFromEnds()
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
        
        mutating func toggle() {
            self = switch self {
            case .own: .opposition
            case .opposition: .own
            }
        }
    }
    
    /// The sum of scores up to this end.
    ///
    /// This adds the scores of all previous ends, and includes
    public func cummulativeScore(after end: End, for team: RelativeTeam) -> Int {
        (ends ?? [])
            .filter { $0.number <= end.number && $0.scoringTeam == team }
            .map { $0.score }
            .reduce(0, +)
    }
    
    /// Calculate the number of ends which match the given statistic.
    /// - Parameter endStatistic: The statistic you are calculating.
    /// - Returns: The proportion of ends which meet the statistic.  This number is between 0–1.
    public func valueFor(_ endStatistic: EndEfficiency) -> Double? {
        let qualifyingEnds = ends?.filter(endStatistic.qualifiesForStatistic) ?? []
        guard qualifyingEnds.count > 0 else { return nil }
        return Double(qualifyingEnds.filter(endStatistic.statisticMet).count) / Double(qualifyingEnds.count)
    }
    
    
    public func switchTeams() {
        withAnimation {
            teamWithHammer.toggle()
            let ownStoneColor = ownTeamStoneColor
            self.ownTeamStoneColor = oppositionTeamStoneColor
            self.oppositionTeamStoneColor = ownStoneColor
            
            ends?.forEach { $0.switchTeams() }
        }
    }
}
