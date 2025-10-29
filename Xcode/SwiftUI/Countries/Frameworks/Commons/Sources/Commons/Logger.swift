//
//  Logger.swift
//  Commons
//
//  Created by Gabriele Nardi   on 29/10/25.
//

import OSLog
import Foundation

public struct Logger: Sendable {
    
    // MARK: - Properties
    
    public let options: Options
    
    public let subsystem: String
    
    public let category: String
    
    public let systemLogger: os.Logger
    
    private let icon: String
    
    // MARK: - Initialization methods
    
    public init(options: Options = .verbose, icon: String, subsystem: String, category: String) {
        self.options = options
        self.icon = icon
        self.subsystem = subsystem
        self.category = category
        self.systemLogger = os.Logger(subsystem: subsystem, category: category)
    }
    
    // MARK: - Public methods
    
    /// OSLog log(level:_ message:) method wrapper using logger options to customize OSLogType.
    /// - Parameters:
    ///   - items: Zero or more items to print.
    ///   - separator: A string to print between each item. The default is a single
    public func log(_ items: Any..., separator: String = " ") {
        let message = items.map { "\($0)" }.joined(separator: separator)
        switch options {
        case .info:
            systemLogger.log(level: .info, "\(icon, privacy: .public) \(message, privacy: .public)")
            
        case .verbose:
            systemLogger.log(level: .debug, "\(icon, privacy: .private) \(message, privacy: .private)")
        default:
            break
        }
    }
    
    public func error(_ items: Any..., separator: String = " ") {
        let message = items.map { "\($0)" }.joined(separator: separator)
        systemLogger.log(level: .error, "\(icon, privacy: .public) \(message, privacy: .public)")
    }
    
    public func logError(_ error: Error, function: String = #function, file: String = #file, line: Int = #line) {
        switch options {
        case .info:
            self.error("Failure: 🛑 \(error.localizedDescription)")
        case .verbose:
            self.error("Failure: 🛑 \(function),\(file),\(line) \(error)")
        default:
            break
        }
    }
}

// MARK: - Options

extension Logger {
    
    public struct Options: OptionSet, Sendable {
        
        // MARK: - Properties

        public static let verbose = Options(rawValue: 1 << 0)
        
        public static let info = Options(rawValue: 1 << 1)
                
        public let rawValue: UInt
        
        // MARK: - Initialization methods

        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }
    }
}
