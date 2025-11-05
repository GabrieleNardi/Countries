//
//  Country+Currency.swift
//  DataModel
//
//  Created by Gabriele Nardi   on 29/10/25.
//

extension Country {
    /// A `Currency`.
    public struct Currency: Codable, Equatable {
        
        /// The name of a valid currency into a country.
        public let name: String
        
        /// The symbol of a valid currency into a country.
        public let symbol: String
    }
}
