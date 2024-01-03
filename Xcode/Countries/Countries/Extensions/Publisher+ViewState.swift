//
//  Publisher+ViewState.swift
//  Countries
//
//  Created by Gabriele Nardi on 27/12/23.
//

import Combine

extension Publisher where Failure: Error {
    
    /// A qol (Quality Of Life) mapper that handle the error as a failure to return.
    /// - Parameter transform: The given transformation
    /// - Returns: The `Publisher` to subscribe.
    func viewStateMap<T>(_ transform: @escaping (Output) -> ViewState<T>) -> AnyPublisher<ViewState<T>, Never> {
        map { transform($0) }
        .catch { Just(.failure($0)) }
        .eraseToAnyPublisher()
    }

    
    /// A qol (Quality Of Life) mapper that wraps the result into the `.loaded() ViewState` and handle the error as a failure to return.
    /// - Returns: A `Publisher` of the `ViewState` to subscribe.
    func viewState() -> AnyPublisher<ViewState<Output>, Never> {
        viewStateMap { ViewState.loaded($0) }
    }
}
