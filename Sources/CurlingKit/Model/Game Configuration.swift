import SwiftUI

/// The rules of a curling game.
public struct GameConfiguration: Equatable, Codable {
    
    /// The number of ends played in the game.
    ///
    /// This does not include extra ends.
    public var numberOfEnds: Int
    
    /// The number of stones played by each team in a game.
    public var stonesPerEnd: Int
    
    /// What occurs in the event a tie exists at the end of the game.
    public var tiebreaker: Tiebreaker = .none
    
    /// The ways in which a tie in points can be resolved.
    public enum Tiebreaker: Int, Codable, CaseIterable, Identifiable {
        public var id: Int { rawValue }
        
        /// No tiebeaker is used, and the game results in a peel.
        case none
        
        /// An extra end is played.
        case extraEnd
        
        /// The team who can draw closest to the shot wins.
        case drawShotChallenge
        
        /// The team with the largest number of won ends is used.
        case numberOfEnds
        
        public var title: String {
            switch self {
            case .none:
                "None"
            case .extraEnd:
                "Extra End"
            case .drawShotChallenge:
                "Draw Shot Challenge"
            case .numberOfEnds:
                "Most Ends Won"
            }
        }
    }
    
    /// The display name for a given game configuration.
    public var title: String?
    
    /// The name of a symbol which can be used in the user interface.
    public var icon: String?
    
    /// A  game of curling with eight ends and no tiebreak.
    static let standard8Ends: Self = Self(numberOfEnds: 8, stonesPerEnd: 8, title: "Standard 8 Ends", icon: "8.circle")
    
    /// A  game of curling with ten ends and no tiebreak.
    static let standard10Ends: Self = Self(numberOfEnds: 10, stonesPerEnd: 8, title: "Standard 10 Ends", icon: "10.circle")
    
    static var allCases: [GameConfiguration] = [.standard8Ends, .standard10Ends]
}
