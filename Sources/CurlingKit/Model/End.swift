import SwiftData
import SwiftUI
import Foundation
import Charts

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
    @Attribute(.allowsCloudEncryption)
    public var number: Int = 1
    
    /* /// The stones which were played during the end.
    @Relationship(deleteRule: .cascade, inverse: \Stone.end)
    public var stones: [Stone]? = []*/
    
    /// The score of the current end.
    ///
    /// The scoring team is stored in ``scoringTeam``.
    /// This value is 0 if the end has been blanked.
    @Attribute(.allowsCloudEncryption)
    public var score: Int = 0
    
    /// The team which scored.
    ///
    /// The score from the team can be determined using ``score``.
    /// This value is `nil` if the end is blanked.
    @Attribute(.allowsCloudEncryption)
    public var scoringTeam: RelativeTeam?
    
    
    // MARK: - Computed Properties
    /// Which team has the last stone.
    ///
    /// This is automatically determined by the scoring team of the preceding end.  If no preceding end exists (i.e., this is the first end), this is determined by the team which was mannually allocated with hammer for the beginning of the game.  See ``/CurlingKit/Game/teamWithHammer``.
    public var teamWithHammer: RelativeTeam {
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
    
    /// A blanked end is one in which no-one scores.
    ///
    /// See ``score``.
    /// 
    @available(*, deprecated, message: "Use the End.result property instead.")
    public var blanked: Bool { score == 0 }
    
    /// A steal occurs when the end is scored by the team without the hammer.
    ///
    /// See ``scoringTeam`` and ``teamWithHammer``.
    public var steal: Bool {
        scoringTeam != teamWithHammer && result != .blanked
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
    
    public enum Result: Int, CaseIterable, Comparable, Identifiable, Plottable, Sendable {
        public static func < (lhs: End.Result, rhs: End.Result) -> Bool {
            lhs.rawValue < rhs.rawValue
        }
        
        case win, blanked, loss
        
        public var id: String { title }
        
        public var title: String {
            switch self {
            case .win:
                String(localized: "Win", comment: "End result")
            case .blanked:
                String(localized: "Blank", comment: "End result")
            case .loss:
                String(localized: "Loss", comment: "End result")
            }
        }
        
        public var color: Color {
            switch self {
            case .loss: .red
            case .blanked: .yellow
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
    
    /// The result of the end, from the perspective of the own team.
    public var result: Result {
        switch scoringTeam {
        case .own: .win
        case .opposition: .loss
        case nil: .blanked
        }
    }
}
