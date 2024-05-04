//
//  Statistic.swift
//
//
//  Created by Nick Baughan on 03/05/2024.
//

import Foundation

protocol Statistic {
    
    /// The title given to the statistic.
    var title: String { get }
    
    /// The description given to the statistic.
    var description: String? { get }
}
