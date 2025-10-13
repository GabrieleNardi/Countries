//
//  CountryCollectionViewModel.swift
//  Countries
//
//  Created by Gabriele Nardi on 27/12/23.
//

import CoreData
import Combine
import UIKit
import Commons
import Core
import DataModel

/// The business logic manager of the CountryCollectionView scene
final class CountryCollectionViewModel: ViewModel {
    
    // MARK: - Type alias
    
    /// The model of the current scene.
    typealias Model = [Country]
    
    // MARK: - Properties
    
    /// The current state of the scene.
    @Published private(set) var state: ViewState<Model> = .idle {
        didSet {
            handleState(state)
        }
    }
    
    /// The current `Model` used by `ViewModel`
    /// and represented by the `ViewController`.
    @Published private(set) var model: Model = []
    
    /// The current `CountryFilter`.
    @Published private(set) var currentFilter: CountryFilter = .all
    
    /// The current `SortOrder`.
    private(set) var currentSortOrder: SortOrder = .forward
    
    /// The flag to check to show the `WizardViewController`.
    let shouldShowWizard = !UserDefaults.checkFirstApplicationLaunch()
    
    /// The application's dependencies.
    let dependencies: AnyAppDependenciesRepresentable
    
    private var allModel: Model = []
    
    private var cancellable: AnyCancellable?
    
    private var fetchedModel: Model = [] {
        didSet {
            if allModel.isEmpty {
                allModel = fetchedModel
                model = allModel
            }
        }
    }
    
    // MARK: - Initialization methods
    
    init(dependencies: AnyAppDependenciesRepresentable) {
        self.dependencies = dependencies
    }
    
    // MARK: - Internal methods
    
    /// Retrieve the `Model` using the dependencies.
    func load() {
        cancellable = dependencies.networkService.getCountries()
            .map { [weak self] model in
                let sortedModel = model.sorted()
                self?.allModel = sortedModel
                
                self?.overwriteModel(newModel: sortedModel)
                
                return ViewState<Model>.loaded(sortedModel)
            }
            .catch { [weak self] error in
                guard let self else {
                    return Just(ViewState<Model>.failure(error))
                }
                
                Task {
                    await self.retrieveModels()
                }
                
                return Just(ViewState<Model>.idle)
            }
            .eraseToAnyPublisher()
            .weakAssign(to: \.state, on: self)
    }
    
    /// Filter the model by the given query.
    /// - Parameter query: The query given to filter the model.
    func filter(for query: String?) {
        guard !allModel.isEmpty, let query else {
            state = .loaded(model)
            return
        }
        
        var filteredModel = filter(currentFilter)
        
        if !query.isEmpty {
            filteredModel = filteredModel.filter { $0.name.common.lowercased().contains(query.lowercased()) }
        }
        
        state = filteredModel.isEmpty ? .noResultsFound : .loaded(filteredModel)
    }
    
    /// Filter the model by the given parameter.
    /// - Parameter filter: The option given to filter the model.
    @discardableResult
    func filter(_ filter: CountryFilter) -> Model {
        guard !allModel.isEmpty else {
            state = .noResultsFound
            return allModel
        }
        
        var filteredModel: Model
        
        switch currentFilter {
        case .all:
            filteredModel = allModel
        case .continent(let continent):
            filteredModel = filterForContinent(continent: continent)
        case .language(let language):
            filteredModel = filterForLanguage(language: language)
        }
        
        if filteredModel.isEmpty {
            state = .noResultsFound
            return []
        } else {
            state = .loaded(filteredModel)
            return filteredModel
        }
    }
    
    /// Sort the model by the given parameter.
    /// - Parameter sort: The option given to sort the model.
    func sort(_ order: SortOrder) {
        guard !model.isEmpty else {
            return
        }
        
        switch order {
        case .forward:
            state = .loaded(model.sorted())
        case .reverse:
            state = .loaded(model.sorted(by: { $0 > $1 }))
        }
        
        currentSortOrder = order
    }
    
    /// Update the current country filter.
    /// - Parameter filter: The given filter.
    func updateCurrentFilter(_ filter: CountryFilter) {
        currentFilter = filter
        self.filter(filter)
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
    
    private func filterForContinent(continent: String) -> Model {
        if continent == "All" {
            allModel
        } else {
            allModel.filter { country in
                country.continent == continent
            }
        }
    }
    
    private func filterForLanguage(language: String) -> Model {
        if language == "All" {
            allModel
        } else {
            allModel.filter { country in
                country.languages.contains(language)
            }
        }
    }
    
    // MARK: - Persistence
    
    // MARK: - DB Management
    
    private func overwriteModel(newModel: Model) {
        Task(priority: .utility) { [weak self] in
            guard let self else {
                return
            }
            
            let storedObjects = await retrieveModels()
            
            await delete(objects: storedObjects)
            
            await saveModels()
        }
    }
    
    private func saveModels() async {
        guard let appDelegate = await UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = await appDelegate.persistentContainer.viewContext
        
        do {
            let encodedModel = try transformModelToData(model: allModel)
            var countriesData: [NSManagedObject] = []
            
            encodedModel.forEach { data in
                let entity = NSEntityDescription.entity(forEntityName: "CountryData", in: managedContext)!
                let countryData = NSManagedObject(entity: entity, insertInto: managedContext)
                countryData.setValue(data, forKey: "data")
                countriesData.append(countryData)
            }
            
            try managedContext.save()
            
        } catch {
            dependencies.loggerService.log(error)
        }
    }
    
    @discardableResult
    private func retrieveModels() async -> [NSManagedObject] {
        guard let appDelegate = await UIApplication.shared.delegate as? AppDelegate else {
            return []
        }
        
        let managedContext = await appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CountryData")
        var fetchedArray = [NSManagedObject]()
        
        do {
            fetchedArray = try managedContext.fetch(fetchRequest)
            fetchedModel = try transformManagedObjectsToModel(objects: fetchedArray).sorted()
        } catch {
            dependencies.loggerService.log(error)
        }
        
        if allModel.isEmpty {
            state = .failure(AppError.coreDataFetchFailed)
        }
        
        return fetchedArray
    }
    
    private func delete(objects: [NSManagedObject]) async {
        guard let appDelegate = await UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = await appDelegate.persistentContainer.viewContext
        
        objects.forEach { object in
            managedContext.delete(object)
        }
        
        do {
            try managedContext.save()
        } catch {
            dependencies.loggerService.log(error)
        }
    }
    
    // MARK: - Transformers
    
    private func transformModelToData(model: Model) throws -> [Data] {
        let encoder = JSONEncoder()
        
        return try model.map { country in
            try encoder.encode(country)
        }
    }
    
    private func transformManagedObjectsToModel(objects: [NSManagedObject]) throws -> Model {
        try objects.map { object in
            let data = object.value(forKey: "data") as! Data
            guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                throw AppError.objectUnwrapping
            }
            
            return Country(from: json)
        }
        
    }
}

// MARK: - Test utilities

extension CountryCollectionViewModel {
    
    func updateModel(with model: Model) {
        self.model = model
        allModel = model
    }
}
