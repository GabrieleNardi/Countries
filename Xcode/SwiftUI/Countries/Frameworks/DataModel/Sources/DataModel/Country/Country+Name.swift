//
//  Country+Name.swift
//  DataModel
//
//  Created by Gabriele Nardi   on 29/10/25.
//

import Foundation

extension Country {
    /// The name of the country, divided into common and official.
    public struct Name: Codable {
        
        /// The common name of the country.
        public let common: String
        
        /// The official name of the country.
        public let official: String
    }
}
