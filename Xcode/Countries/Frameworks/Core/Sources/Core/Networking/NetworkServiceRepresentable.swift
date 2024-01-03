//
//  NetworkServiceRepresentable.swift
//  Countries
//
//  Created by Gabriele Nardi on 27/12/23.
//

import Combine
import Foundation
import DataModel

/// The network service which retrieve data asked by the application.
public protocol NetworkServiceRepresentable {
    
    // MARK: - Properties
    
    /// The singleton of the service.
    static var shared: NetworkServiceRepresentable { get }
    
    /// The cache to store images
    var imageCache: URLCache { get }
    
    // MARK: - Methods
    
    /// It retrieves the countries and provides them wrapped in a `Publisher`.
    /// - Returns: a `Array<Country>` wrapped in a `Publisher` or an error.
    func getCountries() -> AnyPublisher<[Country], Error>
    
    /// It retrieves the pexelsImages and provides them wrapped in a `Publisher`.
    /// - Returns: a `Array<PexelsImage>` wrapped in a `Publisher` or an error.
    func getPexelsImages(country: String) -> AnyPublisher<[PexelsImage], Error>
}
