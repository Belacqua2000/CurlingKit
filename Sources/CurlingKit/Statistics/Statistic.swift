//
//  Statistic.swift
//
//
//  Created by Nick Baughan on 03/05/2024.
//

import Foundation

protocol Statistic: CaseIterable, Identifiable, Sendable {
    
    /// The title given to the statistic.
    var title: String { get }
    
    /// The title given to the statistic.
    var icon: String? { get }
    
    /// The description given to the statistic.
    var description: String? { get }
    
    associatedtype CurlingFeature
    
    /// Determines whether an end qualifies for the statistic.
    var qualifiesForStatistic: (@Sendable (CurlingFeature) -> Bool) { get }
    
    /// Determines whether an end meets the statistic criteria.
    var statisticMet: (@Sendable (CurlingFeature) -> Bool) { get }
}

extension Statistic {
    public var id: String { title }
    
    /// Calculate the number of ends which match the given statistic.
    /// - Parameter features: The statistic you are calculating.
    /// - Returns: The count of curling features which meet the statistic.
    public func countFor(_ features: any Collection<CurlingFeature>) -> Int {
        features
            .filter(qualifiesForStatistic)
            .filter(statisticMet)
            .count
    }
    
    /// Calculate the proportion of ends which match the given statistic.
    /// - Parameter features: The curling feature which you wish to perform the statistic on.
    /// - Returns: The proportion of ends which meet the statistic.  This number is between 0–1.
    public func percentageFor(_ features: any Collection<CurlingFeature>) -> Double? {
        let qualifyingFeatures = features.filter(qualifiesForStatistic)
        guard qualifyingFeatures.count > 0 else { return nil }
        return Double(qualifyingFeatures.filter(statisticMet).count) / Double(qualifyingFeatures.count)
    }
}
