//
//  UserDefined.swift
//  
//
//  Created by Gabriele Nardi on 27/12/23.
//

import Foundation

/// Enum to access the `User-Defined`.
public enum UserDefined {
    case countryFilterContinents
    case countryFilterLanguages
    case countriesBaseUrl
    case countriesAllUrlEndpoint
    case pexelsApiKey
    case pexelsBaseUrl
    case pexelsFiveImageEndpoint
    
    /// The `String` value referred to the enum case
    public var value: String {
        switch self {
        case .countriesBaseUrl:
            guard let baseUrl = Bundle.main.object(forInfoDictionaryKey: Key.countriesBaseUrl.rawValue) as? String else {
                fatalError("Unexpectedly find nil while unwrapping an optional value")
            }
            
            return baseUrl
        case .countriesAllUrlEndpoint:
            guard let endpoint = Bundle.main.object(forInfoDictionaryKey: Key.countriesAllUrlEndpoint.rawValue) as? String else {
                fatalError("Unexpectedly find nil while unwrapping an optional value")
            }
            
            return endpoint
        case .pexelsApiKey:
            guard let apiKey = Bundle.main.object(forInfoDictionaryKey: Key.pexelsApiKey.rawValue) as? String else {
                fatalError("Unexpectedly find nil while unwrapping an optional value")
            }
            
            return apiKey
        case .pexelsBaseUrl:
            guard let baseUrl = Bundle.main.object(forInfoDictionaryKey: Key.pexelsBaseUrl.rawValue) as? String else {
                fatalError("Unexpectedly find nil while unwrapping an optional value")
            }
            
            return baseUrl
        case .pexelsFiveImageEndpoint:
            guard let endpoint = Bundle.main.object(forInfoDictionaryKey: Key.pexelsFiveImageEndpoint.rawValue) as? String else {
                fatalError("Unexpectedly find nil while unwrapping an optional value")
            }
            
            return endpoint
            
        default:
            return ""
        }
    }
    
    /// The `[String]` value referred to the enum case
    public var arrayValue: [String] {
        switch self {
        case .countryFilterContinents:
            guard let countryContinents = Bundle.main.object(forInfoDictionaryKey: Key.countryFilterContinents.rawValue) as? String else {
                fatalError("Unexpectedly find nil while unwrapping an optional value")
            }
            
            
            return countryContinents.split(separator: ",").map { String($0) }
        case .countryFilterLanguages:
            guard let countryLanguages = Bundle.main.object(forInfoDictionaryKey: Key.countryFilterLanguages.rawValue) as? String else {
                fatalError("Unexpectedly find nil while unwrapping an optional value")
            }
            
            return countryLanguages.split(separator: ",").map { String($0) }
        default:
            return []
        }
    }
    
    public enum Key: String {
        case countryFilterContinents = "CountryFilterContinents"
        case countryFilterLanguages = "CountryFilterLanguages"
        case countriesBaseUrl = "CountriesBaseUrl"
        case countriesAllUrlEndpoint = "CountriesAllUrlEndpoint"
        case pexelsApiKey = "PexelsApiKey"
        case pexelsBaseUrl = "PexelsBaseUrl"
        case pexelsFiveImageEndpoint = "PexelsFiveImageEndpoint"
    }
}
