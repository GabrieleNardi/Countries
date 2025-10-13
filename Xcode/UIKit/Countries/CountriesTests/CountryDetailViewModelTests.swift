//
//  CountryDetailViewModelTests.swift
//  CountriesTests
//
//  Created by Gabriele Nardi on 28/12/23.
//

import Combine
import Foundation
import XCTest
import Core
import DataModel
import Mock
@testable import Countries

final class CountryDetailViewModelTests: XCTestCase {
    
    var cancellables = Set<AnyCancellable>()
    
    let dependencies: AnyAppDependenciesRepresentable = MockAppDependencies()
    
    var country = Country.mockValues[0]
    
    override func tearDown() {
        super.tearDown()
        
        cancellables = Set<AnyCancellable>()
    }
    
    func test_init_state() throws {
        let viewModel = CountryDetailViewModel(dependencies: dependencies, country: country)
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
        let viewModel = CountryDetailViewModel(dependencies: dependencies, country: country)
        
        XCTAssertNotNil(viewModel.model.country)
        XCTAssertTrue(viewModel.model.maps.isEmpty)
        XCTAssertTrue(viewModel.model.images.isEmpty)
    }
    
    func test_load() throws {
        let viewModel = CountryDetailViewModel(dependencies: dependencies, country: country)
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
        
        wait(for: [expectation], timeout: 3)
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
}
