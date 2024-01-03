//
//  Device.swift
//
//
//  Created by Gabriele Nardi on 27/12/23.
//

import Foundation
import UIKit

/// The `Device` struct represent the device where the application is running.
public struct Device {
    
    /// The singleton of the `Device` struct.
    public static let main = Device()
    
    /// Type of distribution of the binary.
    public var distribution: Distribution {
        if isTestsSuite {
            return .xcTests
        }
        
        if isDistributionAppStore {
            return .appStore
        }
        
        if isDistributionTestFlight {
            return .testFlight
        }
        
        return .xCodeDebug
    }
    
    /// Check if the application is distributed by the App Store.
    public var isAppStore: Bool {
        guard case .appStore = distribution else {
            return false
        }
        
        return true
    }
    
    /// Check if the application is distributed by the App Store or TestFlight.
    public var isRelease: Bool {
        switch distribution {
        case .appStore, .testFlight:
            return true
        default:
            return false
        }
    }
    
    /// Return `true` when distribution is via xcode or tests, `false` when
    /// TestFlight or AppStore.
    public var isDebug: Bool {
        switch distribution {
        case .xCodeDebug, .xcTests:
            return true
        default:
            return false
        }
    }
    
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
    public var deviceModel: String {
        UIDevice.current.model
    }
    
    // MARK: - Private methods
    
    private let isTestsSuite: Bool = NSClassFromString("XCTest") != nil
    
    private let isDistributionAppStore: Bool = {
        do {
            guard let receiptUrl = Bundle.main.appStoreReceiptURL else {
                return false
            }
            _ = try Data(contentsOf: receiptUrl)
            return true
        } catch {
            return false
        }
    }()
    
    private let isDistributionTestFlight: Bool = {
        #if DEBUG
        return false
        #else
        guard let path = Bundle.main.appStoreReceiptURL?.path else {
            return false
        }
        return path.contains("sandboxReceipt")
        #endif
    }()
}

extension Device {

    /// The `Distribution`by which the application is distributed.
    ///
    /// - testFlight: test flight distribution
    /// - appStore: appstore distribution.
    /// - xCodeDebug: debug.
    public enum Distribution: CustomStringConvertible {
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



