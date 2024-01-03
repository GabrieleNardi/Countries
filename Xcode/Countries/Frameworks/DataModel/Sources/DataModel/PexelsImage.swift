//
//  PexelsImage.swift
//
//
//  Created by Gabriele Nardi on 27/12/23.
//

import Foundation

/// Image coming to the [Pexels website](https://www.pexels.com).
public struct PexelsImage: Decodable, Hashable {
    
    // MARK: - Properties
    
    /// The `URL` of the image.
    public let imageUrl: URL?
    
    /// The name of the photographer who took the picture.
    public let credits: String
    
    // MARK: - Initialization methods
    
    public init(imageUrl: URL?, credits: String) {
        self.imageUrl = imageUrl
        self.credits = credits
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        credits = try values.decode(String.self, forKey: .credits)
        let imageDict = try values.decode([String: String].self, forKey: .imageUrl)
        imageUrl = URL(string: imageDict["medium"] ?? "ImageUrl")
    }
    
    // MARK: - CodingKeys
    
    enum CodingKeys: String, CodingKey {
        case imageUrl = "src"
        case credits = "photographer"
    }
}
