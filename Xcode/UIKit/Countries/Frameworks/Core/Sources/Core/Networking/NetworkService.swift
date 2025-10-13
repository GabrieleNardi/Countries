//
//  NetworkService.swift
//  Countries
//
//  Created by Gabriele Nardi on 27/12/23.
//

import Combine
import Foundation
import Commons
import DataModel

/// The service that handle the remote communication.
/// It is used to get data to send to the application.
public final class NetworkService: NetworkServiceRepresentable {
    
    // MARK: - Properties
    
    /// The shared instance of the `NetworkService`.
    public static let shared: NetworkServiceRepresentable = NetworkService()
    
    /// The image cache as `URLCache`.
    public let imageCache = URLCache(memoryCapacity: 10_000_000, diskCapacity: 1_000_000_000, directory: try? URL.cacheImageURL)
    
    private let timeoutInterval: TimeInterval = 10
    
    // MARK: - Internal methods
    
    /// Get the countries by the APIs.
    /// - Returns: a `Publisher` which wraps the countries.
    public func getCountries() -> AnyPublisher<[Country], Error> {
        Future { [weak self] in
            guard let self,
                  let url = URL(string: "\(UserDefined.countriesBaseUrl.value)\(UserDefined.countriesAllUrlEndpoint.value)")
            else {
                throw NetworkingError.objectUnwrapping
            }
            
            let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: timeoutInterval)
            return try await get(from: request)
        }
        .eraseToAnyPublisher()
    }
    
    /// Get the images regarding a specific country.
    /// - Parameter country: the given country of which to obtain the photos.
    /// - Returns: a `Publisher` which wraps the photos.
    public func getPexelsImages(country: String) -> AnyPublisher<[PexelsImage], Error> {
        Future { [weak self] in
            guard let self,
                  let url = URL(string: "\(UserDefined.pexelsBaseUrl.value)\(UserDefined.pexelsFiveImageEndpoint.value)\(country)")
            else {
                throw NetworkingError.objectUnwrapping
            }
            
            var request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: timeoutInterval)
            request.addValue(UserDefined.pexelsApiKey.value, forHTTPHeaderField: "Authorization")
            
            return try await getPexelsImages(from: request)
        }
        .eraseToAnyPublisher()
    }
    
    // MARK: - Private methods
    
    private func get<D: Decodable>(from request: URLRequest) async throws -> D {
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(D.self, from: data)
    }
    
    private func getPexelsImages(from request: URLRequest) async throws -> [PexelsImage] {
        let (data, _) = try await URLSession.shared.data(for: request)
        let json = try JSONSerialization.jsonObject(with: data) as? [String : Any]
        
        guard let photos = json?["photos"] else {
            return []
        }
        
        let photosData = try JSONSerialization.data(withJSONObject: photos)
        
        return try JSONDecoder().decode([PexelsImage].self, from: photosData)
    }
}
