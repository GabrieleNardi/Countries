//
//  URL+Cache.swift
//  Commons
//
//  Created by Gabriele Nardi   on 29/10/25.
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
