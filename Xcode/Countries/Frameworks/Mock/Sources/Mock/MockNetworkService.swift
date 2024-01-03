//
//  MockNetworkService.swift
//  CountriesTests
//
//  Created by Gabriele Nardi on 27/12/23.
//

import Combine
import Foundation
import Core
import DataModel

/// A mock implementation of the `NetworkServiceRepresentable`
public final class MockNetworkService: NetworkServiceRepresentable {
    
    public static let shared: NetworkServiceRepresentable = MockNetworkService()
    
    public let imageCache = URLCache(memoryCapacity: 10_000_000, diskCapacity: 1_000_000_000, directory: try? URL.cacheImageURL)
    
    public func getCountries() -> AnyPublisher<[Country], Error> {
        Future { promise in
            promise(.success(Country.mockValues))
        }.eraseToAnyPublisher()
    }
    
    public func getPexelsImages(country: String) -> AnyPublisher<[PexelsImage], Error> {
        Future { promise in
            promise(.success(PexelsImage.mockValues))
        }.eraseToAnyPublisher()
    }
}
