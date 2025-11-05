//
//  Country+Flag.swift
//  DataModel
//
//  Created by Gabriele Nardi   on 29/10/25.
//

import Foundation

extension Country {
    /// The flag of the country.
    public struct Flag: Codable, Equatable {
        
        /// The image url of the country flag.
        public let url: URL?
        
        enum CodingKeys: String, CodingKey {
            case url = "png"
        }
        
        public init(url: URL?) {
            self.url = url
        }
        
        public init(from decoder: Decoder) {
            do {
                let container = try decoder.container(keyedBy: Country.Flag.CodingKeys.self)
                self.url = try container.decodeIfPresent(URL.self, forKey: Country.Flag.CodingKeys.url)
            } catch {
                logger.log(error)
                self.url = nil
            }
        }
    }
}
