import SwiftData

@Model
public final class Stone {
    public enum Shot: Int, Codable, CaseIterable, Identifiable {
        case draw, strike, defence
        
        public var id: Int { rawValue }
        
        public var name: String {
            switch self {
            case .draw:
                "Draw"
            case .strike:
                "Strike"
            case .defence:
                "Guard"
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
        case clockwise, anticlockwise
        
        public var id: Int { rawValue }
        
        public var name: String {
            switch self {
            case .clockwise:
                "Clockwise"
            case .anticlockwise:
                "Anticlockwise"
            }
        }
        
        public var icon: String {
            switch self {
            case .clockwise:
                "arrow.clockwise"
            case .anticlockwise:
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
                "Left"
            case .center:
                "Center"
            case .right:
                "Right"
            }
        }
    }
    
    public enum IceAccuracy: Int, Codable, CaseIterable, Identifiable {
        case tight, onTheBrush, wide
        
        public var id: Int { rawValue }
        
        public var name: String {
            switch self {
            case .tight:
                "Tight"
            case .onTheBrush:
                "On the Brush"
            case .wide:
                "Wide"
            }
        }
    }
    
    public enum WeightAccuracy: Int, Codable, CaseIterable, Identifiable {
        case light, onTarget, heavy
        
        public var id: Int { rawValue }
        
        public var name: String {
            switch self {
            case .light:
                "Light"
            case .onTarget:
                "Just Right"
            case .heavy:
                "Heavy"
            }
        }
    }
    
    /// The end which this stone was throwed in.
    public var end: End
    
    public var number: Int
    
    public var notPlayed: Bool = false
    public var shot: Shot?
    public var direction: Direction?
    public var handle: Handle?
    
    public var iceAccuracy: IceAccuracy?
    public var weightAccuracy: WeightAccuracy?
    
    /// Document more details about the shot.
    public var notes: String?
    
    public init(end: End, number: Int, shot: Shot? = nil, direction: Direction? = nil, handle: Handle? = nil, iceAccuracy: IceAccuracy? = nil, weightAccuracy: WeightAccuracy? = nil) {
        self.end = end
        self.number = number
        self.shot = shot
        self.direction = direction
        self.handle = handle
        self.iceAccuracy = iceAccuracy
        self.weightAccuracy = weightAccuracy
    }
}
