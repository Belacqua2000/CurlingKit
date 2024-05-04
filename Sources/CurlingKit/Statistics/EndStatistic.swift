//
//  EndStatistic.swift
//
//
//  Created by Nick Baughan on 03/05/2024.
//

import Foundation

public struct EndEfficiency: Statistic, Identifiable {
    public var title: String
    
    public var description: String?
    
    public var id: String { title }
    
    /// Determines whether an end qualifies for the statistic.
    var qualifiesForStatistic: ((End) -> Bool)
    
    /// Determines whether an end meets the statistic criteria.
    var statisticMet: ((End) -> Bool)
    
    public static let hammerEfficiency = Self(
        title: "Hammer Efficiency",
        description: "Ends where your team had the hammer and scored ≥ 2.",
        qualifiesForStatistic: { end in
            end.teamWithHammer == .own
        },
        statisticMet: { end in
            end.teamWithHammer == .own && end.scoringTeam == .own && end.score >= 2
        }
    )
    
    public static let forceEfficiency = Self(
        title: "Force Efficiency",
        description: "Ends where the opponent had the hammer and scored 1.",
        qualifiesForStatistic: { end in
            end.teamWithHammer == .opposition
        },
        statisticMet: { end in
            end.teamWithHammer == .opposition && end.scoringTeam == .opposition && end.score == 1
        }
    )
    
    public static let stealEfficiency = Self(
        title: "Steal Efficiency",
        description: "Ends where the opponent had the hammer and you scored.",
        qualifiesForStatistic: { end in
            end.teamWithHammer == .opposition
        },
        statisticMet: { end in
            end.teamWithHammer == .opposition && end.scoringTeam == .own
        }
    )
}
