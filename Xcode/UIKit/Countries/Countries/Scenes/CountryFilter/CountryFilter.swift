//
//  CountryFilter.swift
//  Countries
//
//  Created by Gabriele Nardi on 27/12/23.
//

import Foundation

/// The filter used to display countries in the `CountryListViewController`.
enum CountryFilter: Equatable {
    case all
    case continent(String)
    case language(String)
    
    /// The associated value of the `CountryFilter`.
    var associatedValue: String {
        switch self {
        case .all:
            return "All"
        case .continent(let value), .language(let value):
            return value
        }
    }
}
