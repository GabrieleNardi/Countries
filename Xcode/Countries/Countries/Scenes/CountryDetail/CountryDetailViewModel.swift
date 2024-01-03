//
//  CountryDetailViewModel.swift
//  Countries
//
//  Created by Gabriele Nardi on 28/12/23.
//

import Combine
import MapKit
import UIKit
import Commons
import Core
import DataModel

/// The viewModel of the `CountryDetailViewController`.
final class CountryDetailViewModel: ViewModel {
    
    // MARK: - ViewModel properties
    
    typealias Model = DataModel
    
    @Published private(set) var state: ViewState<Model> = .idle {
        didSet {
            handleState(state)
        }
    }
    
    @Published private(set) var model: Model
    
    @Published private(set) var maps: [UIImage] = Array(repeating: UIImage(systemName: "photo"), count: 5).compactMap { $0 }
    
    // MARK: - Properties
    
    /// The` Country` of which we are presenting the details
    let country: Country
    
    private let dependencies: AppDependenciesRepresentable
    
    private var cancellable: AnyCancellable?
    
    // MARK: - Initialization methods
    
    init(dependencies: AppDependenciesRepresentable, country: Country) {
        self.dependencies = dependencies
        self.country = country
        self.model = DataModel(country: country)
    }
    
    // MARK: - ViewModel methods
    
    func load() {
        state = .loading
        
        cancellable = makeDataModel()
            .map {
                .loaded($0)
            }
            .catch { [weak self] error in
                guard let self else {
                    return Just(ViewState<Model>.noResultsFound)
                }
                
                dependencies.loggerService.log(error)
                
                return Just(ViewState<Model>.loaded(DataModel(country: country, maps: maps)))
            }
            .eraseToAnyPublisher()
            .weakAssign(to: \.state, on: self)
    }
    
    // MARK: - Internal methods
    
    func getHeaderText(for section: Int) -> String {
        let maps: LocalizedStringResource = "Maps"
        let infos: LocalizedStringResource = "Infos"
        let translations: LocalizedStringResource = "Translations"
        let photos: LocalizedStringResource = "Photos from: \(country.name.common)"
        
        return switch section {
        case 1:
            String(localized: maps)
        case 2:
            String(localized: infos)
        case 3:
            String(localized: translations)
        case 4:
            String(localized: photos)
        default:
            ""
        }
    }
    
    // MARK: - Private methods
    
    private func handleState(_ state: ViewState<Model>) {
        switch state {
        case .loaded(let value):
            model = value
        case .noResultsFound:
            model = DataModel(country: country)
        default:
            break
        }
    }
    
    private func makeDataModel() -> AnyPublisher<DataModel, Error> {
        let countryName = country.name.common
        return Publishers.Zip(getSnapshots(for: country.coordinates), dependencies.networkService.getPexelsImages(country: countryName))
            .map { [weak self] in
                guard let self else {
                    return DataModel()
                }
                
                return DataModel(country: country, maps: $0, images: $1)
            }
            .eraseToAnyPublisher()
    }
    
    private func getSnapshots(for coordinates: Country.Coordinates) -> AnyPublisher<[UIImage], Error> {
        let coordinates = CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude)
        
        return Future {
            try await withThrowingTaskGroup(of: UIImage.self) { group in
                
                group.addTask {
                    try await MapSnapshotter.provideSnapshot(for: coordinates, span: MKCoordinateSpan(latitudeDelta: 13, longitudeDelta: 13), type: .satellite)
                }
                group.addTask {
                    try await MapSnapshotter.provideSnapshot(for: coordinates, span: MKCoordinateSpan(latitudeDelta: 13, longitudeDelta: 13), type: .hybridFlyover)
                }
                group.addTask {
                    try await MapSnapshotter.provideSnapshot(for: coordinates, span: MKCoordinateSpan(latitudeDelta: 4, longitudeDelta: 4), type: .hybridFlyover)
                }
                group.addTask {
                    try await MapSnapshotter.provideSnapshot(for: coordinates, span: MKCoordinateSpan(latitudeDelta: 11, longitudeDelta: 11), type: .standard)
                }
                group.addTask {
                    try await MapSnapshotter.provideSnapshot(for: coordinates, span: MKCoordinateSpan(latitudeDelta: 4, longitudeDelta: 4), type: .standard)
                }
                
                return try await group.reduce([UIImage]()) { partialResult, currentResult in
                    var accumulator = partialResult
                    accumulator.append(currentResult)
                    
                    return accumulator
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

// MARK: - Extensions

// MARK: - DataModel

extension CountryDetailViewModel {
    
    struct DataModel {
        
        // MARK: - Properties
        
        let country: Country?
        
        let maps: [UIImage]
        
        let images: [PexelsImage]
        
        var isEmpty: Bool {
            country == nil
            && maps.isEmpty
            && images.isEmpty
        }
        
        // MARK: - Initialization methods
        
        init(country: Country? = nil, maps: [UIImage] = [], images: [PexelsImage] = []) {
            self.country = country
            self.maps = maps
            self.images = images
        }
    }
}

// MARK: - Hashable

extension CountryDetailViewModel.DataModel: Hashable {
    
    // MARK: - Properties
    
    var id: UUID { UUID() }
    
    // MARK: - Equatable methods
    
    static func == (lhs: CountryDetailViewModel.DataModel, rhs: CountryDetailViewModel.DataModel) -> Bool {
        lhs.country == rhs.country && rhs.images == rhs.images
    }
    
    // MARK: - Hashable methods
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - Transformers

extension CountryDetailViewModel {
    
    // MARK: - Internal Type alias
    
    typealias Item = CountryDetailViewController.Item
    
    // MARK: - Internal methods
    
    /// Transforms the `DataModel` to the `Item Array` for main infos.
    /// - Parameter dataModel: the given `DataModel`
    /// - Returns: An `Array` of `Item`.
    func transformToMainInfos(from dataModel: DataModel) -> [Item] {
        let population: LocalizedStringResource = "Population"
        let people: LocalizedStringResource = "people"
        let area: LocalizedStringResource = "Area"
        let coordinates: LocalizedStringResource = "Coordinates"
        let degree: LocalizedStringResource = "degree"
        let currency: LocalizedStringResource = "Currency"
        
        var items = [Item]()
        let populationValue = prepareNumber(for: NSNumber(value: country.population))
        let areaValue = prepareNumber(for: NSNumber(value: country.area))
        
        items = [
            Item.info(title: String(localized: population), value: populationValue, unit: String(localized: people)),
            Item.info(title: String(localized: area), value: areaValue, unit: "km²"),
            Item.info(title: String(localized: coordinates), value: country.coordinates.description, unit: String(localized: degree))
        ]
        
        if let firstCurrency = country.currencies.first {
            items.append(Item.info(title: String(localized: currency), value: firstCurrency.symbol, unit: firstCurrency.name))
        }
        
        return items
    }
    
    /// Transforms the `DataModel` to the `Item Array` for main maps.
    /// - Parameter dataModel: the given `DataModel`
    /// - Returns: An `Array` of `Item`.
    func transformToMaps(from dataModel: DataModel) -> [Item] {
        dataModel.maps.compactMap { Item.map($0) }
    }
    
    /// Transforms the `DataModel` to the `Item Array` for infos.
    /// - Parameter dataModel: the given `DataModel`
    /// - Returns: An `Array` of `Item`.
    func transformToInfos(from dataModel: DataModel) -> [Item] {
        let capital: LocalizedStringResource = "Capital"
        let timezones: LocalizedStringResource = "Timezones"
        
        var items = transformToMainInfos(from: dataModel)
        
        items.insert(Item.info(title: String(localized: capital), value: country.capital), at: 0)
        
        if let first = dataModel.country?.timezones.first {
            if let last = country.timezones.last, first != last {
                items.append(Item.info(title: String(localized: timezones), value: "\(first) - \(last)"))
            } else {
                items.append(Item.info(title: String(localized: timezones), value: first))
            }
        }
        
        return items
    }
    
    /// Transforms the `DataModel` to the `Item Array` for translations.
    /// - Parameter dataModel: the given `DataModel`
    /// - Returns: An `Array` of `Item`.
    func transformToTranslations(from dataModel: DataModel) -> [Item] {
        dataModel.country?.translations.map { Item.info(title: $0.language, value: $0.name, unit: nil) } ?? []
    }
    
    /// Transforms the `DataModel` to the `Item Array` for photos.
    /// - Parameter dataModel: the given `DataModel`
    /// - Returns: An `Array` of `Item`.
    func transformToPhotos(from dataModel: DataModel) -> [Item] {
        dataModel.images.compactMap { Item.image($0) }
    }
    
    // MARK: - Private methods
    
    private func prepareNumber(for number: NSNumber) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale.current
        numberFormatter.numberStyle = .decimal
        
        return numberFormatter.string(from: number) ?? "-"
    }
}
