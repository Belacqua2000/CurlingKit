import SwiftData
import Foundation

@Model
public final class PracticeSession {
    public var date: Date
    @Relationship(deleteRule: .cascade) var ends: [End] = []
    
    public init(date: Date, ends: [End] = []) {
        self.date = date
        self.ends = ends
    }
}
