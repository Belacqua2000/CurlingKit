//
//  GameStatistic.swift
//
//
//  Created by Nick Baughan on 07/05/2024.
//

import Foundation

public struct GameStatistic: Statistic {
    var qualifiesForStatistic: (@Sendable (Game) -> Bool)
    
    var statisticMet: (@Sendable (Game) -> Bool)
    
    typealias CurlingFeature = Game
    
    var title: String
    
    var icon: String?
    
    var description: String?
    
    public static let allCases: [GameStatistic] = []
}
