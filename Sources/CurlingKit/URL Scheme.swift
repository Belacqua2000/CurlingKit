//
//  URL Scheme.swift
//  CurlingKit
//
//  Created by Nick Baughan on 25/10/2024.
//

import Foundation

public struct AilsaURL {
    static let scheme = "www"
    
    static let host = "nickbaughan.com"
    
    static let path: String = "/ailsa/app-data"
    
    public static let settingsURL: URL = URL(string: "www.nickbaughan.com/ailsa/app-data/settings")!
    public static let statisticsURL: URL = URL(string: "www.nickbaughan.com/ailsa/app-data/statistics")!
    public static let awardsURL: URL = URL(string: "www.nickbaughan.com/ailsa/app-data/awards")!
    
    public enum ParseError: Error {
        case cannotFormComponents, incorrectHost, cannotFindItem
    }
}

//public var url: URL {
//    var components = URLComponents()
//    components.scheme = ConsolidateURL.scheme
//    components.host = ConsolidateURL.Host.openTag.rawValue
//    components.queryItems = [
//        .init(name: "id", value: id?.uuidString)
//    ]
//    
//    return components.url!
//}
