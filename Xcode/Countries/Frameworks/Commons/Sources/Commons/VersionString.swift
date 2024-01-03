//
//  VersionString.swift
//
//
//  Created by Gabriele Nardi on 27/12/23.
//

import Foundation

/// An utility struct to provide release and build number, and comparing versions
public struct VersionString: RawRepresentable, Codable {
    
    // MARK: - Properties
    
    /// The release version formatted as "x.x.x" representing major, minor and patch number.
    public var shortVersion: String { "\(major).\(minor).\(patch)" }
    
    /// The release version formatted as "x.x.x.x" representing major, minor, patch and the build number.
    public var longVersion: String { "\(shortVersion).\(build)" }
    
    /// The major version number as `String`.
    public let major: String
    
    /// The minor version number as `String`.
    public let minor: String
    
    /// The patch version number as `String`.
    public let patch: String
    
    /// The build version number as `String`.
    public let build: String
    
    /// The `VersionString` raw value.
    public let rawValue: String
    
    // MARK: - Initialization methods
    
    public init(rawValue: String) {
        self.init(version: rawValue)
    }
    
    private init(version: String) {
        self.rawValue = version
        let versionSplitted = version.split(separator: ".")
        
        if let major = versionSplitted[safe: 0] {
            self.major = String(major)
        } else {
            self.major = "0"
        }
        
        if let minor = versionSplitted[safe: 1] {
            self.minor = String(minor)
        } else {
            self.minor = "0"
        }
        
        if let patch = versionSplitted[safe: 2] {
            self.patch = String(patch)
        } else {
            self.patch = "0"
        }
        
        if let build = versionSplitted[safe: 3] {
            self.build = String(build)
        } else {
            self.build = "0"
        }
    }
}

// MARK: - Comparable

extension VersionString: Comparable {

    public static func == (lhs: VersionString, rhs: VersionString) -> Bool {
        lhs.rawValue.compare(rhs.rawValue, options: .numeric) == .orderedSame
    }
    
    public static func < (lhs: VersionString, rhs: VersionString) -> Bool {
        lhs.rawValue.compare(rhs.rawValue, options: .numeric) == .orderedAscending
    }
    
    public static func > (lhs: VersionString, rhs: VersionString) -> Bool {
        lhs.rawValue.compare(rhs.rawValue, options: .numeric) == .orderedDescending
    }
}

// MARK: - CustomStringConvertible

extension VersionString: CustomStringConvertible {
    
    public var description: String {
        "v.\(self.rawValue)"
    }
}

