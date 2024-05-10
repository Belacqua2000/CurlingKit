//
//  End+File.swift
//  
//
//  Created by Nick Baughan on 10/05/2024.
//

import Foundation
import SwiftData

struct EndFile {
    
    public struct Version1: ExportVersion {
        public static var fileExtension: String = ""
        
        var fileName: String {
            number.formatted()
        }
        
        public static var version: Int = 1
        
        /// The index of the end.
        ///
        /// This is typically between 1 and 8.
        var number: Int = 0
        
        /// Whether this end has been played.
        var played: Bool = true
        
        var score: Int = 0
        var scoringTeam: Game.RelativeTeam?
        
        
        public init(from model: End) {
            number = model.number
            played = model.played
            score = model.score
            scoringTeam = model.scoringTeam
        }
        
        public func modelFromFile(using context: ModelContext) -> End {
            let newEnd = End(number: number)
            newEnd.played = played
            newEnd.score = score
            newEnd.scoringTeam = scoringTeam
            
            return newEnd
        }
    }
}
