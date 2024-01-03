//
//  FilterCollectionViewModel.swift
//  Countries
//
//  Created by Gabriele Nardi on 27/12/23.
//

import Foundation
import Commons
import Core

/// The business logic manager of the filter scene.
final class FilterCollectionViewModel: ViewModel {
    
    // MARK: - Type alias
    
    typealias Model = [String]
    
    // MARK: - Properties
    
    @Published private(set) var state: ViewState<Model> = .idle {
        didSet {
            handleState(state)
        }
    }
    
    @Published private(set) var model: Model = []
    
    /// All the values for the selected `CountryFilter`.
    private(set) var allModel: Model = []
    
    /// The current `CountryFilter`.
    let filter: CountryFilter
    
    private let dependencies: AnyAppDependenciesRepresentable
    
    // MARK: - Initialization methods
    
    init(filter: CountryFilter, dependencies: AnyAppDependenciesRepresentable) {
        self.filter = filter
        self.dependencies = dependencies
    }
    
    // MARK: - Internal properties
    
    func load() {
        state = .loading
        let model: Model
        
        switch filter {
        case .continent:
            model = UserDefined.countryFilterContinents.arrayValue
            state = .loaded(model)
        case .language:
            model = UserDefined.countryFilterLanguages.arrayValue
            state = .loaded(model)
        default:
            model = []
            state = .noResultsFound
        }
        
        allModel = model
    }
    
    /// Filter the model by the given query.
    /// - Parameter query: The query given to filter the model.
    func filter(query: String?) {
        guard !allModel.isEmpty, let query, !query.isEmpty else {
            state = .loaded(allModel)
            return
        }
        
        let filteredModel = allModel.filter { $0.lowercased().contains(query.lowercased()) }
        
        state = filteredModel.isEmpty ? .noResultsFound : .loaded(filteredModel)
    }
    
    // MARK: - Private methods
    
    private func handleState(_ state: ViewState<Model>) {
        switch state {
        case .loaded(let value):
            model = value
        case .noResultsFound:
            model = []
        default:
            break
        }
    }
}
