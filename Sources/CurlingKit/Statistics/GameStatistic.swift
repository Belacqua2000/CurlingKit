//
//  GameStatistic.swift
//
//
//  Created by Nick Baughan on 07/05/2024.
//

import Foundation

public struct GameStatistic: Statistic {
    var qualifiesForStatistic: ((Game) -> Bool)
    
    var statisticMet: ((Game) -> Bool)
    
    typealias CurlingFeature = Game
    
    var title: String
    
    var icon: String?
    
    var description: String?
    
    public static var allCases: [GameStatistic] = []
}
