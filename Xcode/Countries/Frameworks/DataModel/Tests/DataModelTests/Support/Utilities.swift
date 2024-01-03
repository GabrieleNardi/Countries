//
//  Utilities.swift
//
//
//  Created by Gabriele Nardi on 30/09/23.
//

import Foundation


func getDecodableFromJSON<D: Decodable>(name: String) throws -> D {
    let url = Bundle.module.url(forResource: name, withExtension: "json")!
    let data = try Data(contentsOf: url)
    
    return try JSONDecoder().decode(D.self, from: data)
}
