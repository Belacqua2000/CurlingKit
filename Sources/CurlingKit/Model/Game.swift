import SwiftData
import SwiftUI
import Charts

/// A curling match between two teams.
@Model
public final class Game {
    // MARK: - Details
    
    @Attribute(.allowsCloudEncryption, .preserveValueOnDeletion)
    public var stableIdentifier: UUID = UUID()
    
    /// A user-configurable title given to the game.
    @Attribute(.allowsCloudEncryption)
    public var title: String = String(localized: "Untitled Game", bundle: .module, comment: "Default game title")
    
    /// Additional notes written about the game.
    @Attribute(.allowsCloudEncryption)
    public var notes = String()
    
    /// The start date when the game took place.
    @Attribute(.allowsCloudEncryption)
    public var date: Date = Date.now
    
    // MARK: - Configuration
    /// The opposition team.
    @Attribute(.allowsCloudEncryption)
    public var opponent = String()
    
    /// The competition this game is part of.
    @Attribute(.allowsCloudEncryption)
    public var competition: Competition?
    
    /// The winner of the tiebreaker.
    @Attribute(.allowsCloudEncryption)
    public var tiebreakerWinner: RelativeTeam?
    
    /// Whether you start with the hammer.
    @Attribute(.allowsCloudEncryption)
    public var teamWithHammer: RelativeTeam = RelativeTeam.own
    
    /// The color of stones the player's own team are delivering..
    @Attribute(.allowsCloudEncryption)
    public var ownTeamStoneColor: StoneColor = StoneColor.red
    
    /// The color of stones the opposition team are delivering..
    @Attribute(.allowsCloudEncryption)
    public var oppositionTeamStoneColor: StoneColor = StoneColor.yellow
    
    @Attribute(.allowsCloudEncryption)
    public var position = Position.lead
    
    /// The ends of this game.
    @Relationship(deleteRule: .cascade, inverse: \End.game)
    public var ends: [End]? = []
    
    public var endCount: Int { ends?.count ?? 20}
    
    // MARK: - Outcomes
    
    /// The outcome of a game.
    public enum Outcome: Codable, Comparable, Plottable, CaseIterable, Sendable {
        case lose, peel, win
        public var title: String {
            switch self {
            case .lose:
                String(localized: "Game_Loss", bundle: .module, comment: "Game outcome title")
            case .peel:
                String(localized: "Draw_Outcome", defaultValue: "Draw", bundle: .module, comment: "Game outcome title")
            case .win:
                String(localized: "Win", bundle: .module, comment: "Game outcome title")
            }
        }
        
        public var color: Color {
            switch self {
            case .lose: .red
            case .peel: .yellow
            case .win: .green
            }
        }
        
        public var primitivePlottable: String {
            title
        }
        
        public init?(primitivePlottable: String) {
            guard let value = Self.allCases.first(where: { $0.title == primitivePlottable }) else { return nil }
            self = value
        }
    }
    
    public enum ScoreCalculationMode: Int, Codable {
        case ends, final
    }
    
    @Attribute(.allowsCloudEncryption)
    public private(set) var scoreCalculation = ScoreCalculationMode.ends
    
    /// The final score of the game of the user's team.
    ///
    /// This can be entered manually if there are no ends, or can be calculated automatically using ``calculateScoresFromEnds()``
    @Attribute(.allowsCloudEncryption)
    public var ownScore: Int = 0
    
    /// The final score of the game of the opposition team.
    ///
    /// This can be entered manually if there are no ends, or can be calculated automatically using ``calculateScoresFromEnds()``
    @Attribute(.allowsCloudEncryption)
    public var oppositionScore: Int = 0
    
    public func setScoreCalculation(to calculationMode: ScoreCalculationMode, numberOfEnds: Int = 8, using modelContext: ModelContext) {
        scoreCalculation = calculationMode
        
        if calculationMode == .ends {
            adjustEndCount(to: numberOfEnds, using: modelContext)
            updateScoresFromEnds()
        }
    }
    
    /// Calculates the total score from ends.
    ///
    /// This sums the scores entered for all of the game's ends and updates ``ownScore`` and ``oppositionScore`` accordingly.
    public func updateScoresFromEnds() {
        guard scoreCalculation == .ends else { return }
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
            
            if ownScore != oppositionScore {
                tiebreakerWinner = nil
            }
        }
    }
    
    /// The outcome of the game.
    public var outcome: Outcome {
        if ownScore == oppositionScore {
            switch tiebreakerWinner {
            case .own:
                return .win
            case .opposition:
                return .lose
            case nil:
                return .peel
            }
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
        
//        title = Self.defaultTitle(for: date)
    }
    
    var exportTitle: String {
        let date = date.formatted(.dateTime.weekday(.wide).day().month(.abbreviated).year())
        var newTitle = "\(date) Game"
        if !opponent.isEmpty {
            newTitle.append(" vs \(opponent)")
        }
        return newTitle
//        title = newTitle
    }
    
//    static func defaultTitle(for date: Date) -> String {
//        let weekDay = date.formatted(.dateTime.weekday(.wide))
//        let hour = Calendar.current.component(.hour, from: date)
//        
//        let timeOfDay = switch hour {
//        case 0...11: String(localized: "Morning", bundle: .module)
//        case 12...17: String(localized: "Afternoon", bundle: .module)
//        case 18...23: String(localized: "Evening", bundle: .module)
//        default: String(localized: "Morning", bundle: .module)
//        }
//        
//        return [weekDay, timeOfDay, "Game"].joined(separator: " ")
//    }
    
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
        } else if let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: .now), (sevenDaysAgo ..< .now).contains(date) {
            return date.formatted(.dateTime.weekday(.wide).hour().minute())
        } else {
            return date.formatted(.dateTime.weekday(.abbreviated).day().month().year().hour().minute())
        }
    }
    
    /*public var allStones: [Stone] {
        (ends ?? [])
            .flatMap { $0.stones ?? [] }
            .sorted { stone1, stone2 in
                if stone1.end == stone2.end {
                    stone1.number < stone2.number
                } else {
                    stone1.end?.number ?? 1 < stone2.end?.number ?? 1
                }
            }
    }*/
    
    // MARK: - Functions
//    public func dateChanged(oldDate: Date, newDate: Date) {
//        if title == Self.defaultTitle(for: oldDate) {
//            withAnimation {
//                title = Self.defaultTitle(for: newDate)
//            }
//        }
//    }
    
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
    
    public func adjustEndCount(to requestedEndCount: Int, using context: ModelContext) {
        withAnimation {
            while endCount < requestedEndCount {
                addEnd(using: context)
            }
            
            while endCount > requestedEndCount {
                if let lastEnd = ends?.sorted(using: SortDescriptor(\.number)).last {
                    ends?.removeAll { $0.id == lastEnd.id }
                    context.delete(lastEnd)
                }
            }
            updateScoresFromEnds()
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
            if scoreCalculation == .ends {
                updateScoresFromEnds()
            } else {
                let ownScore = ownScore
                self.ownScore = oppositionScore
                self.oppositionScore = ownScore
            }
        }
    }
}
