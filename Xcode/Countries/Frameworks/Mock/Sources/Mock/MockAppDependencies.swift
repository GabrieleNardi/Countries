//
//  MockAppDependencies.swift
//
//
//  Created by Gabriele Nardi on 27/12/23.
//

import Foundation
import Commons
import Core

/// The dependencies for the mock target of the application.
public struct MockAppDependencies: AppDependenciesRepresentable {
    
    public var networkService: NetworkServiceRepresentable { MockNetworkService.shared }
    
    public var loggerService: Logger { Logger(options: .verbose, icon: "🕹️🚀", subsystem: Bundle.main.bundleIdentifier ?? "-", category: "/mockApp") }
    
    public var device: Device { Device.main }
    
    public init() { }
}
