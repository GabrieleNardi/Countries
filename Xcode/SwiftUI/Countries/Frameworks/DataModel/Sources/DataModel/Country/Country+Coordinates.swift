//
//  Country+Coordinates.swift
//  DataModel
//
//  Created by Gabriele Nardi   on 29/10/25.
//

import Foundation

extension Country {
    /// Standard coordinate system divided into latitude and longitude.
    public struct Coordinates: Codable, Equatable {
        
        /// The latitude of the country.
        public let latitude: Double
        
        /// The longitude of the country.
        public let longitude: Double
    }
}

// MARK: - CustomStringConvertible

extension Country.Coordinates: CustomStringConvertible {
    
    private static let numberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale.current
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2
        
        return numberFormatter
    }()
    
    public var description: String {
        let latitude = Country.Coordinates.numberFormatter.string(from: NSNumber(value: latitude)) ?? "-"
        let longitude = Country.Coordinates.numberFormatter.string(from:  NSNumber(value: longitude)) ?? "-"
        
        return "\(latitude), \(longitude)"
    }
}
