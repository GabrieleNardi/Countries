//
//  Utilities.swift
//
//
//  Created by Gabriele Nardi on 27/12/23.
//

import Foundation
import Commons

let logger = Logger(options: .verbose, icon: "🕹️", subsystem: Bundle.main.bundleIdentifier ?? "-", category: "/Mock")
        
func getDecodableFromJSON<D: Decodable>(name: String) throws -> D {
    let url = Bundle.module.url(forResource: name, withExtension: "json")!
    
    do {
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(D.self, from: data)
    } catch {
        logger.log(error)
        throw error
    }
}
