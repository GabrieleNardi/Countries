//
//  ViewModel.swift
//  Countries
//
//  Created by Gabriele Nardi on 27/12/23.
//

import Foundation
import Core

/// A common interface for the view models.
protocol ViewModel: ObservableObject {
    
    // MARK: - Associated type
    
    associatedtype Model
    
    // MARK: - Properties
    
    /// The current `State` of the `ViewModel`.
    var state: ViewState<Model> { get }
    
    /// The current `Model` of the `ViewModel`.
    var model: Model { get }
    
    // MARK: - Internal methods
    
    /// It loads the `Model` for the `ViewModel`.
    func load()
}

typealias AnyViewModel = any ViewModel
