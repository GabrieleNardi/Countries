//
//  AppError.swift
//  Countries
//
//  Created by Gabriele Nardi on 27/12/23.
//

import Foundation

/// The Application's custom `Error`.
enum AppError: Error {
    case generic
    case objectUnwrapping
    case coreDataFetchFailed
}

extension AppError {
    
    var localizedDescription: LocalizedStringResource {
        switch self {
        case .generic, .objectUnwrapping:
            return "An error has occured, try again please"
        case .coreDataFetchFailed:
            return "There was an error retrieving data from the database, try again please"
        }
    }
}
