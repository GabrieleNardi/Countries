//
//  ViewState.swift
//  Countries
//
//  Created by Gabriele Nardi on 27/12/23.
//

import Foundation

/// The representation of the state's `ViewModel`.
enum ViewState<Value> {
    case idle
    case loading
    case loaded(Value)
    case paged(Value)
    case noResultsFound
    case failure(Error)
}

extension ViewState {
    
    var isLoading: Bool {
        switch self {
        case .loading:
            return true
        default:
            return false
        }
    }
    
    var isLoaded: Bool {
        switch self {
        case .loaded:
            return true
        default:
            return false
        }
    }
    
    var isPaged: Bool {
        switch self {
        case .paged:
            return true
        default:
            return false
        }
    }
    
    var isNoResultsFound: Bool {
        switch self {
        case .noResultsFound:
            return true
        default:
            return false
        }
    }
    
    var isError: Bool {
        switch self {
        case .failure:
            return true
        default:
            return false
        }
    }
}

typealias VoidViewState = ViewState<Void>
