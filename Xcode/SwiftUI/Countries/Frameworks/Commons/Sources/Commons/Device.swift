//
//  Device.swift
//  Commons
//
//  Created by Gabriele Nardi   on 18/10/25.
//

import Foundation
import UIKit
import StoreKit

/// The `Device` struct represent the device where the application is running.
public struct Device: Sendable {
    
    /// The singleton of the `Device` struct.
    public static let main = Device()
    
    // MARK: - Public Properties
    
    /// Check if the device where the application is distributed is a `Simulator`.
    public var isSimulator: Bool {
    #if targetEnvironment(simulator)
        true
    #else
        false
    #endif
    }
    
    /// The version of the app wrapped in the struct `VersionString`.
    public var appVersion: VersionString {
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "0.0.0"
        let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "0"
        
        return VersionString(rawValue: "\(version).\(build)")
    }
    
    /// The model of the current device.
    @MainActor
    public var deviceModel: String {
        UIDevice.current.model
    }
    
    // MARK: - Distribution Detection
    
    /// Type of distribution of the binary.
    public var distribution: Distribution {
        get async {
            if isTestsSuite {
                return .xcTests
            }
            
            if await isDistributionAppStore {
                return .appStore
            }
            
            if isDistributionTestFlight {
                return .testFlight
            }
            
            return .xCodeDebug
        }
    }
    
    /// Check if the application is distributed by the App Store.
    public var isAppStore: Bool {
        get async {
            await distribution == .appStore
        }
    }
    
    /// Check if the application is distributed by the App Store or TestFlight.
    public var isRelease: Bool {
        get async {
            switch await distribution {
            case .appStore, .testFlight:
                return true
            default:
                return false
            }
        }
    }
    
    /// Return `true` when distribution is via xcode or tests, `false` when
    /// TestFlight or AppStore.
    public var isDebug: Bool {
        get async {
            switch await distribution {
            case .xCodeDebug, .xcTests:
                return true
            default:
                return false
            }
        }
    }
    
    // MARK: - Private Properties
    
    private let isTestsSuite: Bool = NSClassFromString("XCTest") != nil
    
    private var isDistributionAppStore: Bool {
        get async {
            if #available(iOS 18.0, *) {
                do {
                    _ = try await AppTransaction.shared
                    return true
                } catch {
                    return false
                }
            } else {
                guard let receiptUrl = Bundle.main.appStoreReceiptURL,
                      (try? Data(contentsOf: receiptUrl)) != nil else {
                    return false
                }
                return true
            }
        }
    }
    
    private var isDistributionTestFlight: Bool {
        #if DEBUG
        return false
        #else
        guard let path = Bundle.main.appStoreReceiptURL?.path else {
            return false
        }
        return path.contains("sandboxReceipt")
        #endif
    }
    
    // MARK: - Initialization
    
    private init() {}
}

// MARK: - Distribution Enum

extension Device {
    
    /// The `Distribution` by which the application is distributed.
    public enum Distribution: Sendable, Equatable, CustomStringConvertible {
        case xcTests
        case testFlight
        case appStore
        case xCodeDebug
        
        public var description: String {
            switch self {
            case .xcTests:
                return "xctests"
            case .testFlight:
                return "testflight"
            case .appStore:
                return "appstore"
            case .xCodeDebug:
                return "xcode"
            }
        }
    }
}

// MARK: - Synchronous Convenience Methods

extension Device {
    
    /// Synchronous check for tests environment (available immediately)
    public var isTests: Bool {
        isTestsSuite
    }
    
    /// Synchronous check for simulator (available immediately)
    public var isRunningOnSimulator: Bool {
        isSimulator
    }
}
