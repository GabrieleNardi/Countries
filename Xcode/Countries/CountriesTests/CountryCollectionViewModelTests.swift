//
//  CountriesTests.swift
//  CountriesTests
//
//  Created by Gabriele Nardi on 27/12/23.
//

import Combine
import XCTest
import Core
import DataModel
import Mock
@testable import Countries

final class CountryCollectionViewModelTests: XCTestCase {
    
    var cancellables = Set<AnyCancellable>()
    
    let dependencies: AnyAppDependenciesRepresentable = MockAppDependencies()
    
    override func tearDown() {
        super.tearDown()
        
        cancellables = Set<AnyCancellable>()
    }
    
    func test_init_state() throws {
        let viewModel = CountryCollectionViewModel(dependencies: dependencies)
        let expectation = expectation(description: "After the initialization the state should be .idle.")
        
        viewModel.$state.sink { state in
            switch state {
            case .idle:
                return expectation.fulfill()
            default:
                break
            }
        }
        .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_init_model() throws {
        let viewModel = CountryCollectionViewModel(dependencies: dependencies)
        
        XCTAssertTrue(viewModel.model.isEmpty)
    }
    
    func test_load() throws {
        let viewModel = CountryCollectionViewModel(dependencies: dependencies)
        let expectation = expectation(description: "After the load() method the state should be .loaded.")
        
        viewModel.load()
        
        viewModel.$state.sink { state in
            switch state {
            case .loaded:
                return expectation.fulfill()
            default:
                break
            }
        }
        .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_load_models() throws {
        let viewModel = CountryCollectionViewModel(dependencies: dependencies)
        let expectation = expectation(description: "After the load() method the model shouldn't be empty.")
        
        viewModel.load()
        
        viewModel.$model
            .sink { countries in
                if !countries.isEmpty {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_filter_query() throws {
        let viewModel = CountryCollectionViewModel(dependencies: dependencies)
        viewModel.updateModel(with: Country.mockValues)
        let filteredCountryCount = 1
        let expectation = expectation(description: "After the filter(for:) method there must be just one country.")
        
        viewModel.filter(for: "Italy")
        
        viewModel.$model
            .sink { countries in
                let filteredCount = countries.count
                
                if filteredCount == filteredCountryCount {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_filter_continent() throws {
        let viewModel = CountryCollectionViewModel(dependencies: dependencies)
        viewModel.updateModel(with: Country.mockValues)
        let filteredContinentCount = 55
        let expectation = expectation(description: "After the filter(_:) method the all continents should be Europe.")
        
        viewModel.filter(.continent("Europe"))
        
        viewModel.$model
            .sink { countries in
                
                let filteredCount = countries.map { $0.continent }
                    .filter { $0 == "Europe" }
                    .count
                
                if filteredCount == filteredContinentCount {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_filter_languages() throws {
        let viewModel = CountryCollectionViewModel(dependencies: dependencies)
        viewModel.updateModel(with: Country.mockValues)
        let filteredLanguagesCount = 91
        let expectation = expectation(description: "After the filter(_:) method the all languages should be English.")
        
        viewModel.filter(.language("English"))
        
        viewModel.$model.sink { countries in
            
            let filteredCount = countries.map { $0.languages }
                .reduce([], +)
                .filter { $0 == "English" }
                .count
            
            if filteredLanguagesCount == filteredCount {
                expectation.fulfill()
            }
        }
        .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_sort_ascendant() throws {
        let viewModel = CountryCollectionViewModel(dependencies: dependencies)
        viewModel.updateModel(with: Country.mockValues)
        let expectation = expectation(description: "After the sort(_: .forward) method the sort should be ascendant.")
        
        viewModel.sort(.forward)
        
        viewModel.$model.sink { countries in
            if let firstCountry = countries.first,
               let secondCountry = countries[safe: 1] {
                
                XCTAssertLessThan(firstCountry, secondCountry)
                expectation.fulfill()
            }
        }
        .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_sort_descendant() throws {
        let viewModel = CountryCollectionViewModel(dependencies: dependencies)
        viewModel.updateModel(with: Country.mockValues)
        let expectation = expectation(description: "After the sort(_: .forward) method the sort should be descendant.")
        
        viewModel.sort(.reverse)
        
        viewModel.$model.sink { countries in
            if let firstCountry = countries.first,
               let secondCountry = countries[safe: 1] {
                
                XCTAssertGreaterThan(firstCountry, secondCountry)
                expectation.fulfill()
            }
        }
        .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
}
