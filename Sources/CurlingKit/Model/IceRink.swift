/*import CoreLocation
import SwiftData
import SwiftUI

/// The location where the curling match was played.
@Model
public final class IceRink {
    var name: String
    
    var stoneColors: Array<StoneColor> = [StoneColor.red, StoneColor.yellow]
    
    var lattitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    
    var location: CLLocationCoordinate2D? {
        guard let lattitude, let longitude else { return nil }
        return CLLocationCoordinate2D(latitude: lattitude, longitude: longitude)
    }
    
    public init(name: String) {
        self.name = name
    }
}

/// An individual rating given to an ice rink.
public struct IceRating: Codable {
    
    enum Speed: Codable {
        case slow, fast, aboutRight
    }
    
    enum Swing: Codable {
        case small, medium, large
    }
    
    var overall: Int
    var speed: Speed
    var swing: Swing
}
*/
