//
//  Mock.swift
//
//
//  Created by Gabriele Nardi on 27/12/23.
//

import Foundation
import DataModel

extension Country {
    
    /// Add a mock array to `Country`.
    public static let mockValues: [Country] = {
        do {
           return try getDecodableFromJSON(name: "AllCountries")
        } catch {
            return []
        }
    }()
}

extension PexelsImage {
    
    /// Add a mock array to `PexelsImage`.
    public static let mockValues: [PexelsImage] = {
        do {
           return try getDecodableFromJSON(name: "AllPexelsImages")
        } catch {
            return []
        }
    }()
}
