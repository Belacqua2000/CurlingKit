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
        var number: Int
        
        var score: Int
        var scoringTeam: RelativeTeam?
        
        
        public init(from model: End) {
            number = model.number
            score = model.score
            scoringTeam = model.scoringTeam
        }
        
        public func modelFromFile(using context: ModelContext) -> End {
            let newEnd = End(number: number)
            newEnd.score = score
            newEnd.scoringTeam = scoringTeam
            
            return newEnd
        }
    }
}
