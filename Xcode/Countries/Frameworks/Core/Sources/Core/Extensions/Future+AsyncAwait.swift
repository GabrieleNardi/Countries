//
//  Future+AsyncAwait.swift
//
//
//  Created by Gabriele Nardi on 27/12/23.
//

import Combine

extension Future where Failure == Error {
 
    convenience init(operation: @escaping () async throws -> Output) {
        self.init { promise in
            Task {
                do {
                    let output = try await operation()
                    promise(.success(output))
                } catch {
                    promise(.failure(error))
                }
            }
        }
    }
}
