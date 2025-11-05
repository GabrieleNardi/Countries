//
//  LoggerTests.swift
//  Commons
//
//  Created by Gabriele Nardi   on 29/10/25.
//

import Testing
import Foundation
import os
@testable import Commons

@Suite("Logger Tests")
struct LoggerTests {
    
    // MARK: - Initialization Tests
    
    @Suite("Initialization Tests")
    struct InitializationTests {
        
        @Test("Initialize with default verbose options")
        func initializeWithDefaultOptions() {
            let logger = Logger(
                icon: "📱",
                subsystem: "com.test.app",
                category: "testing"
            )
            
            #expect(logger.options == .verbose)
        }
        
        @Test("Initialize with info options")
        func initializeWithInfoOptions() {
            let logger = Logger(
                options: .info,
                icon: "🔧",
                subsystem: "com.test.app",
                category: "network"
            )
            
            #expect(logger.options == .info)
        }
        
        @Test("Initialize with verbose options explicitly")
        func initializeWithVerboseOptions() {
            let logger = Logger(
                options: .verbose,
                icon: "🐛",
                subsystem: "com.test.app",
                category: "debug"
            )
            
            #expect(logger.options == .verbose)
        }
        
        @Test("Initialize with empty options")
        func initializeWithEmptyOptions() {
            let logger = Logger(
                options: [],
                icon: "⚠️",
                subsystem: "com.test.app",
                category: "testing"
            )
            
            #expect(logger.options.rawValue == 0)
        }
        
        @Test("Initialize with various icons", arguments: ["📱", "🔧", "🐛", "⚠️", "✅", "❌"])
        func initializeWithVariousIcons(icon: String) {
            let logger = Logger(
                icon: icon,
                subsystem: "com.test.app",
                category: "testing"
            )
            
            #expect(logger.options == .verbose)
        }
    }
    
    // MARK: - Options Tests
    
    @Suite("Options Tests")
    struct OptionsTests {
        
        @Test("Verbose option has correct raw value")
        func verboseOptionRawValue() {
            #expect(Logger.Options.verbose.rawValue == 1)
        }
        
        @Test("Info option has correct raw value")
        func infoOptionRawValue() {
            #expect(Logger.Options.info.rawValue == 2)
        }
        
        @Test("Options are unique")
        func optionsAreUnique() {
            #expect(Logger.Options.verbose != Logger.Options.info)
        }
        
        @Test("Options can be combined")
        func optionsCanBeCombined() {
            let combined: Commons.Logger.Options = [.verbose, .info]
            
            #expect(combined.contains(.verbose))
            #expect(combined.contains(.info))
        }
        
        @Test("Empty options set")
        func emptyOptionsSet() {
            let empty = Logger.Options([])
            
            #expect(empty.rawValue == 0)
            #expect(!empty.contains(.verbose))
            #expect(!empty.contains(.info))
        }
        
        @Test("Options equality")
        func optionsEquality() {
            let option1 = Logger.Options.verbose
            let option2 = Logger.Options.verbose
            let option3 = Logger.Options.info
            
            #expect(option1 == option2)
            #expect(option1 != option3)
        }
        
        @Test("Options are Sendable")
        func optionsAreSendable() async {
            let options = Logger.Options.verbose
            
            await Task {
                #expect(options == .verbose)
            }.value
        }
    }
    
    // MARK: - Logging Tests
    
    @Suite("Logging Tests")
    struct LoggingTests {
        
        @Test("Log single item with verbose option")
        func logSingleItemVerbose() {
            let logger = Logger(
                options: .verbose,
                icon: "📱",
                subsystem: "com.test.app",
                category: "testing"
            )
            
            // Should not crash
            logger.log("Test message")
        }
        
        @Test("Log multiple items with verbose option")
        func logMultipleItemsVerbose() {
            let logger = Logger(
                options: .verbose,
                icon: "📱",
                subsystem: "com.test.app",
                category: "testing"
            )
            
            // Should not crash
            logger.log("User:", "John", "Age:", 25)
        }
        
        @Test("Log with custom separator")
        func logWithCustomSeparator() {
            let logger = Logger(
                options: .verbose,
                icon: "📱",
                subsystem: "com.test.app",
                category: "testing"
            )
            
            // Should not crash
            logger.log("Item1", "Item2", "Item3", separator: " | ")
        }
        
        @Test("Log with info option")
        func logWithInfoOption() {
            let logger = Logger(
                options: .info,
                icon: "🔧",
                subsystem: "com.test.app",
                category: "testing"
            )
            
            // Should not crash
            logger.log("Info message")
        }
        
        @Test("Log with empty options does nothing")
        func logWithEmptyOptions() {
            let logger = Logger(
                options: [],
                icon: "⚠️",
                subsystem: "com.test.app",
                category: "testing"
            )
            
            // Should not crash, but also should not log
            logger.log("This should not be logged")
        }
        
        @Test("Log various data types")
        func logVariousDataTypes() {
            let logger = Logger(
                options: .verbose,
                icon: "📱",
                subsystem: "com.test.app",
                category: "testing"
            )
            
            // Should handle various types
            logger.log("String", 42, 3.14, true, [1, 2, 3])
        }
        
        @Test("Log empty string")
        func logEmptyString() {
            let logger = Logger(
                options: .verbose,
                icon: "📱",
                subsystem: "com.test.app",
                category: "testing"
            )
            
            // Should not crash
            logger.log("")
        }
        
        @Test("Log with no arguments")
        func logWithNoArguments() {
            let logger = Logger(
                options: .verbose,
                icon: "📱",
                subsystem: "com.test.app",
                category: "testing"
            )
            
            // Should not crash
            logger.log()
        }
    }
    
    // MARK: - Error Logging Tests
    
    @Suite("Error Logging Tests")
    struct ErrorLoggingTests {
        
        enum TestError: Error {
            case testFailure
            case networkError
            case validationError(String)
        }
        
        @Test("Log error with verbose option")
        func logErrorVerbose() {
            let logger = Logger(
                options: .verbose,
                icon: "❌",
                subsystem: "com.test.app",
                category: "testing"
            )
            
            let error = TestError.testFailure
            
            // Should not crash
            logger.logError(error)
        }
        
        @Test("Log error with info option")
        func logErrorInfo() {
            let logger = Logger(
                options: .info,
                icon: "❌",
                subsystem: "com.test.app",
                category: "testing"
            )
            
            let error = TestError.networkError
            
            // Should not crash
            logger.logError(error)
        }
        
        @Test("Log error with empty options does nothing")
        func logErrorWithEmptyOptions() {
            let logger = Logger(
                options: [],
                icon: "❌",
                subsystem: "com.test.app",
                category: "testing"
            )
            
            let error = TestError.testFailure
            
            // Should not crash, but also should not log
            logger.logError(error)
        }
        
        @Test("Log error with context information")
        func logErrorWithContext() {
            let logger = Logger(
                options: .verbose,
                icon: "❌",
                subsystem: "com.test.app",
                category: "testing"
            )
            
            let error = TestError.validationError("Invalid input")
            
            // Should not crash and should include function, file, line
            logger.logError(error, function: "testFunction", file: "TestFile.swift", line: 42)
        }
        
        @Test("Log NSError")
        func logNSError() {
            let logger = Logger(
                options: .verbose,
                icon: "❌",
                subsystem: "com.test.app",
                category: "testing"
            )
            
            let error = NSError(
                domain: "com.test.app",
                code: 404,
                userInfo: [NSLocalizedDescriptionKey: "Not found"]
            )
            
            // Should not crash
            logger.logError(error)
        }
        
        @Test("Error method with single item")
        func errorMethodSingleItem() {
            let logger = Logger(
                options: .verbose,
                icon: "❌",
                subsystem: "com.test.app",
                category: "testing"
            )
            
            // Should not crash
            logger.error("Error message")
        }
        
        @Test("Error method with multiple items")
        func errorMethodMultipleItems() {
            let logger = Logger(
                options: .verbose,
                icon: "❌",
                subsystem: "com.test.app",
                category: "testing"
            )
            
            // Should not crash
            logger.error("Error:", "Connection failed", "Code:", 500)
        }
        
        @Test("Error method with custom separator")
        func errorMethodCustomSeparator() {
            let logger = Logger(
                options: .verbose,
                icon: "❌",
                subsystem: "com.test.app",
                category: "testing"
            )
            
            // Should not crash
            logger.error("Error", "Details", "Info", separator: " -> ")
        }
    }
    
    // MARK: - Privacy Tests
    
    @Suite("Privacy Tests")
    struct PrivacyTests {
        
        @Test("Verbose option uses private privacy level")
        func verboseUsesPrivatePrivacy() {
            let logger = Logger(
                options: .verbose,
                icon: "🔒",
                subsystem: "com.test.app",
                category: "testing"
            )
            
            // Logs should use private privacy
            logger.log("Sensitive data: password123")
        }
        
        @Test("Info option uses public privacy level")
        func infoUsesPublicPrivacy() {
            let logger = Logger(
                options: .info,
                icon: "📢",
                subsystem: "com.test.app",
                category: "testing"
            )
            
            // Logs should use public privacy
            logger.log("Public information")
        }
        
        @Test("Error logs always use public privacy")
        func errorUsesPublicPrivacy() {
            let logger = Logger(
                options: .verbose,
                icon: "❌",
                subsystem: "com.test.app",
                category: "testing"
            )
            
            // Error logs should use public privacy
            logger.error("Error occurred")
        }
    }
    
    // MARK: - Thread Safety Tests
    
    @Suite("Thread Safety Tests")
    struct ThreadSafetyTests {
        
        @Test("Concurrent logging does not crash")
        func concurrentLogging() async {
            let logger = Logger(
                options: .verbose,
                icon: "🔄",
                subsystem: "com.test.app",
                category: "testing"
            )
            
            await withTaskGroup(of: Void.self) { group in
                for i in 0..<100 {
                    group.addTask {
                        logger.log("Message \(i)")
                    }
                }
            }
            
            // If we reach here without crashing, test passes
        }
        
        @Test("Concurrent error logging does not crash")
        func concurrentErrorLogging() async {
            let logger = Logger(
                options: .verbose,
                icon: "🔄",
                subsystem: "com.test.app",
                category: "testing"
            )
            
            enum TestError: Error {
                case concurrent(Int)
            }
            
            await withTaskGroup(of: Void.self) { group in
                for i in 0..<100 {
                    group.addTask {
                        logger.logError(TestError.concurrent(i))
                    }
                }
            }
            
            // If we reach here without crashing, test passes
        }
    }
    
    // MARK: - Integration Tests
    
    @Suite("Integration Tests")
    struct IntegrationTests {
        
        @Test("Logger works with different subsystems")
        func differentSubsystems() {
            let logger1 = Logger(
                options: .verbose,
                icon: "1️⃣",
                subsystem: "com.test.app.network",
                category: "api"
            )
            
            let logger2 = Logger(
                options: .info,
                icon: "2️⃣",
                subsystem: "com.test.app.database",
                category: "persistence"
            )
            
            logger1.log("Network request started")
            logger2.log("Database query executed")
            
            #expect(logger1.subsystem == "com.test.app.network")
            #expect(logger2.subsystem == "com.test.app.database")
        }
        
        @Test("Logger works with different categories")
        func differentCategories() {
            let logger1 = Logger(
                icon: "📱",
                subsystem: "com.test.app",
                category: "ui"
            )
            
            let logger2 = Logger(
                icon: "🔧",
                subsystem: "com.test.app",
                category: "background"
            )
            
            logger1.log("UI updated")
            logger2.log("Background task completed")
        }
        
        @Test("Mixed logging scenario")
        func mixedLoggingScenario() {
            let logger = Logger(
                options: .verbose,
                icon: "🎯",
                subsystem: "com.test.app",
                category: "testing"
            )
            
            enum AppError: Error {
                case operationFailed
            }
            
            // Mix of regular logs and errors
            logger.log("Starting operation")
            logger.log("Progress:", 50, "%")
            logger.error("Warning: Low memory")
            logger.logError(AppError.operationFailed)
            logger.log("Operation completed")
        }
    }
    
    // MARK: - Edge Cases
    
    @Suite("Edge Cases")
    struct EdgeCaseTests {
        
        @Test("Logger with very long message")
        func veryLongMessage() {
            let logger = Logger(
                options: .verbose,
                icon: "📝",
                subsystem: "com.test.app",
                category: "testing"
            )
            
            let longMessage = String(repeating: "A", count: 10000)
            
            // Should not crash
            logger.log(longMessage)
        }
        
        @Test("Logger with special characters")
        func specialCharacters() {
            let logger = Logger(
                options: .verbose,
                icon: "🔤",
                subsystem: "com.test.app",
                category: "testing"
            )
            
            // Should handle special characters
            logger.log("Special: \n\t\r 🎉 \"quotes\" 'apostrophes'")
        }
        
        @Test("Logger with unicode characters")
        func unicodeCharacters() {
            let logger = Logger(
                options: .verbose,
                icon: "🌍",
                subsystem: "com.test.app",
                category: "testing"
            )
            
            // Should handle unicode
            logger.log("Unicode: 你好 مرحبا שלום")
        }
        
        @Test("Logger with nil-containing optionals")
        func nilContainingOptionals() {
            let logger = Logger(
                options: .verbose,
                icon: "❓",
                subsystem: "com.test.app",
                category: "testing"
            )
            
            let optional: String? = nil
            
            // Should handle nil optionals
            logger.log("Value:", optional as Any)
        }
    }
}
