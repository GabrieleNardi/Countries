//
//  Publisher+WeakAssign.swift
//  Countries
//
//  Created by Gabriele Nardi on 27/12/23.
//

import Combine
import Foundation

extension Publisher where Failure == Never {
    
    
    /// A weak reference to the value.
    /// - Parameters:
    ///   - keyPath: The path
    ///   - object: the given object
    /// - Returns: The `Cancellable` to subscribe
    public func weakAssign<T: AnyObject>(to keyPath: ReferenceWritableKeyPath<T, Output>, on object: T) -> AnyCancellable {
        receive(on: RunLoop.main)
            .sink { [weak object] value in
            object?[keyPath: keyPath] = value
        }
    }
}
