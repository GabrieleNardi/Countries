//
//  RandomAccessCollection+Subscript.swift
//
//
//  Created by Gabriele Nardi on 27/12/23.
//

import Foundation

extension RandomAccessCollection {
    
    /// Safe subscript to avoid out of bounds exception
    /// - Parameter safe: The index of the element to return
    /// - Returns The `Element` corresponding to the given index else `nil`
    public subscript (safe index: Index) -> Element? {
        guard !isEmpty, index >= startIndex, index < endIndex else {
            return nil
        }
        
        return self[index]
    }
}
