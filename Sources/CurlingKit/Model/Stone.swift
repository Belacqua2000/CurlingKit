/*import SwiftData

@Model
public final class Stone {
    public enum Shot: Int, Codable, CaseIterable, Identifiable {
        case draw, strike, defence
        
        public var id: Int { rawValue }
        
        public var name: String {
            switch self {
            case .draw:
                String(localized: "Draw", bundle: .module, comment: "The stone shot.")
            case .strike:
                String(localized: "Strike", bundle: .module, comment: "The stone shot.")
            case .defence:
                String(localized: "Guard", bundle: .module, comment: "The stone shot.")
            }
        }
        
        public var icon: String {
            switch self {
            case .draw:
                "target"
            case .strike:
                "scope"
            case .defence:
                "shield"
            }
        }
    }
    
    public enum Handle: Int, Codable, CaseIterable, Identifiable {
        case inturn, outturn
        
        public var id: Int { rawValue }
        
        public var name: String {
            switch self {
            case .inturn:
                String(localized: "In-turn", bundle: .module)
            case .outturn:
                String(localized: "Out-turn", bundle: .module)
            }
        }
        
        /// The direction which the stone will rotate when looking at it from above.
        ///
        /// This depends on the handedness of the player delivering.
        public func rotation(handedness: Handedness) -> String {
            switch (self, handedness) {
            case (.inturn, .rightHanded), (.outturn, .leftHanded):
                String(localized: "Clockwise", bundle: .module)
            case (.outturn, .rightHanded), (.inturn, .leftHanded):
                String(localized: "Counterclockwise", bundle: .module)
            }
        }
        
        /// The icon corresponding to the direction which the stone will rotate when looking at it from above.
        ///
        /// This depends on the handedness of the player delivering.
        public func icon(handedness: Handedness) -> String {
            switch (self, handedness) {
            case (.inturn, .rightHanded), (.outturn, .leftHanded):
                "arrow.clockwise"
            case (.outturn, .rightHanded), (.inturn, .leftHanded):
                "arrow.counterclockwise"
            }
        }
    }
    
    /// The point which you slide out to before releasing the stone.
    ///
    /// This is relative to the person delivering the stone.
    public enum Direction: Int, Codable, CaseIterable, Identifiable {
        case left, center, right
        
        public var id: Int { rawValue }
        
        public var name: String {
            switch self {
            case .left:
                String(localized: "Left", bundle: .module)
            case .center:
                String(localized: "Center", bundle: .module)
            case .right:
                String(localized: "Right", bundle: .module)
            }
        }
    }
    
    public enum IceAccuracy: Int, Codable, CaseIterable, Identifiable {
        case tight, onTheBrush, wide
        
        public var id: Int { rawValue }
        
        public var name: String {
            switch self {
            case .tight:
                String(localized: "Tight", bundle: .module, comment: "The ice accuracy.")
            case .onTheBrush:
                String(localized: "On the Brush", bundle: .module, comment: "The ice accuracy.")
            case .wide:
                String(localized: "Wide", bundle: .module, comment: "The ice accuracy.")
            }
        }
    }
    
    public enum WeightAccuracy: Int, Codable, CaseIterable, Identifiable {
        case light, onTarget, heavy
        
        public var id: Int { rawValue }
        
        public var name: String {
            switch self {
            case .light:
                String(localized: "Light", bundle: .module, comment: "The weight accuracy.")
            case .onTarget:
                String(localized: "Just Right", bundle: .module, comment: "The weight accuracy.")
            case .heavy:
                String(localized: "Heavy", bundle: .module, comment: "The weight accuracy.")
            }
        }
    }
    
    /// The end which this stone was throwed in.
    @Relationship
    public var end: End?
    
    public var number: Int
    
    public var notPlayed: Bool = false
    public var shot: Shot?
    public var direction: Direction?
    public var handle: Handle?
    
    public var iceAccuracy: IceAccuracy?
    public var weightAccuracy: WeightAccuracy?
    
    /// Document more details about the shot.
    public var notes: String?
    
    /// The number of the stone in the game.
    public var overallNumber: Int {
        (end?.game?.allStones.firstIndex(of: self) ?? 0)
        + 1
    }
    
    public init(end: End, number: Int, shot: Shot? = nil, direction: Direction? = nil, handle: Handle? = nil, iceAccuracy: IceAccuracy? = nil, weightAccuracy: WeightAccuracy? = nil, notes: String? = nil) {
        self.end = end
        self.number = number
        self.shot = shot
        self.direction = direction
        self.handle = handle
        self.iceAccuracy = iceAccuracy
        self.weightAccuracy = weightAccuracy
        self.notes = notes
    }
}
*/
