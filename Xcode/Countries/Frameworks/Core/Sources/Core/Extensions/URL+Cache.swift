//
//  URL+Cache.swift
//
//
//  Created by Gabriele Nardi on 27/12/23.
//

import Foundation

extension URL {
    
    /// The url for the cached images directory.
    public static var cacheImageURL: URL {
        get throws {
            let cachesURL = try FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            return cachesURL.appendingPathComponent("com.countries.images")
        }
    }
}
