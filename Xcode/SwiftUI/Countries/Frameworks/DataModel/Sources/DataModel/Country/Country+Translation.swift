//
//  Country+Translation.swift
//  DataModel
//
//  Created by Gabriele Nardi   on 29/10/25.
//

extension Country {
    /// `Translation` is a structure that provide the translated name and the language in which the name of the country is translated.
    public struct Translation: Codable, Equatable {
        
        /// The language in which the country name is translated.
        public let language: String
        
        /// The name of the country translated.
        public let name: String
    }
}
