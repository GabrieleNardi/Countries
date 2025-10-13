//
//  AppDependenciesRepresentable.swift
//
//
//  Created by Gabriele Nardi on 27/12/23.
//

import Foundation
import Commons

/// The dependencies of the application.
public protocol AppDependenciesRepresentable {
    
    /// The network service responsible to retrieve data for the application.
    var networkService: NetworkServiceRepresentable { get }
    
    /// The logger service which will be used in the application to
    /// log message or errors.
    var loggerService: Logger { get }
    
    /// The representation of the current device.
    var device: Device { get }
}

public typealias AnyAppDependenciesRepresentable = any AppDependenciesRepresentable

/// The dependencies the application will use.
public struct AppDependencies: AppDependenciesRepresentable {
    
    public var networkService: NetworkServiceRepresentable { NetworkService.shared }
    
    public var loggerService: Logger { Logger(options: Device.main.isDebug ? .verbose : .info, icon: "🚀", subsystem: Bundle.main.bundleIdentifier ?? "-", category: "/app") }
    
    public var device: Device { Device.main }
    
    public init() { }
}
