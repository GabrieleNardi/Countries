//
//  Item.swift
//  Countries
//
//  Created by Gabriele Nardi   on 13/10/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
