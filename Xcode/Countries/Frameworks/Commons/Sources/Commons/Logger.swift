//
//  Logger.swift
//
//
//  Created by Gabriele Nardi on 27/12/23.
//

import OSLog
import Foundation

/// The main `Logger`, it is a configuration of the `os.Logger`.
public struct Logger {
    
    // MARK: - Properties
    
    /// The configured Options of the `Logger`.
    public let options: Options
    
    /// The wrapped `os.Logger`.
    private let logger: os.Logger
    
    /// The icon used to makes easier recognize the log
    /// written by the current configuration of the `Logger`.
    private let icon: String
    
    // MARK: - Initialization methods
    
    public init(options: Options = .verbose, icon: String, subsystem: String, category: String) {
        self.options = options
        self.icon = icon
        self.logger = os.Logger(subsystem: subsystem, category: category)
    }
    
    // MARK: - Public methods
    
    /// Log a message by using `os.log`.
    /// - Note: The OSLogType available are `.info` and `.debug` depending on the options.
    /// - Parameters:
    ///   - items: Items to concatenate making the message to log
    ///   - separator: the separator between the given items
    public func log(_ items: Any..., separator: String = " ") {
        let message = items.map { "\($0)" }.joined(separator: separator)
        switch options {
        case .info:
            logger.log(level: .info, "\(icon, privacy: .public) \(message, privacy: .public)")
            
        case .verbose:
            logger.log(level: .debug, "\(icon, privacy: .private) \(message, privacy: .private)")
        default:
            break
        }
    }
    
    /// Log a message by using `os.log`.
    /// - Note: The OSLogType is `.error`.
    /// - Parameters:
    ///   - items: Items to concatenate making the message to log
    ///   - separator: the separator between the given items
    public func error(_ items: Any..., separator: String = " ") {
        let message = items.map { "\($0)" }.joined(separator: separator)
        logger.log(level: .error, "\(icon, privacy: .public) \(message, privacy: .public)")
    }
    
    /// Log an error by using `os.log` useful while debugging an external module.
    /// - Note: The OSLogType available are `.info` and `.debug` depending on the options.
    /// - Parameters:
    ///   - items: Items to concatenate making the message to log
    ///   - separator: the separator between the given items
    public func log(_ error: Error, function: String = #function, file: String = #file, line: Int = #line) {
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
    
    /// An `OptionSet` of options to handle the detail level of the logs.
    public struct Options: OptionSet {
        
        // MARK: - Properties
        
        /// The `verbose` level of logs. It tells the logger to write complete and detailed logs.
        public static let verbose = Options(rawValue: 1 << 0)
        
        /// The `info` level of logs. It tells the logger to write concise logs.
        public static let info = Options(rawValue: 1 << 1)
        
        /// The `Options`' rawValue.
        public let rawValue: UInt
        
        // MARK: - Initialization methods

        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }
    }
}
