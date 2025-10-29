//
//  VersionStringTests.swift
//  Commons
//
//  Created by Gabriele Nardi   on 29/10/25.
//


import Testing
import Foundation
@testable import Commons

@Suite("VersionString Tests")
struct VersionStringTests {
    
    // MARK: - Initialization Tests
    
    @Suite("Initialization Tests")
    struct InitializationTests {
        
        @Test("Initialize with full version string")
        func initializeWithFullVersion() {
            let version = VersionString(rawValue: "1.2.3.456")
            
            #expect(version.major == "1")
            #expect(version.minor == "2")
            #expect(version.patch == "3")
            #expect(version.build == "456")
            #expect(version.rawValue == "1.2.3.456")
        }
        
        @Test("Initialize with short version string")
        func initializeWithShortVersion() {
            let version = VersionString(rawValue: "2.5.7")
            
            #expect(version.major == "2")
            #expect(version.minor == "5")
            #expect(version.patch == "7")
            #expect(version.build == "0")
        }
        
        @Test("Initialize with major and minor only")
        func initializeWithMajorMinor() {
            let version = VersionString(rawValue: "3.4")
            
            #expect(version.major == "3")
            #expect(version.minor == "4")
            #expect(version.patch == "0")
            #expect(version.build == "0")
        }
        
        @Test("Initialize with major only")
        func initializeWithMajorOnly() {
            let version = VersionString(rawValue: "5")
            
            #expect(version.major == "5")
            #expect(version.minor == "0")
            #expect(version.patch == "0")
            #expect(version.build == "0")
        }
        
        @Test("Initialize with empty string")
        func initializeWithEmptyString() {
            let version = VersionString(rawValue: "")
            
            #expect(version.major == "0")
            #expect(version.minor == "0")
            #expect(version.patch == "0")
            #expect(version.build == "0")
        }
        
        @Test(
            "Initialize with various version formats",
            arguments: [
                ("1.0.0.1", "1", "0", "0", "1"),
                ("10.5.2.999", "10", "5", "2", "999"),
                ("0.0.1.0", "0", "0", "1", "0"),
                ("99.99.99.99", "99", "99", "99", "99")
            ]
        )
        func initializeWithVariousFormats(
            input: String,
            expectedMajor: String,
            expectedMinor: String,
            expectedPatch: String,
            expectedBuild: String
        ) {
            let version = VersionString(rawValue: input)
            
            #expect(version.major == expectedMajor)
            #expect(version.minor == expectedMinor)
            #expect(version.patch == expectedPatch)
            #expect(version.build == expectedBuild)
        }
    }
    
    // MARK: - Version Format Tests
    
    @Suite("Version Format Tests")
    struct VersionFormatTests {
        
        @Test("Short version format is correct")
        func shortVersionFormat() {
            let version = VersionString(rawValue: "1.2.3.456")
            
            #expect(version.shortVersion == "1.2.3")
        }
        
        @Test("Long version format is correct")
        func longVersionFormat() {
            let version = VersionString(rawValue: "1.2.3.456")
            
            #expect(version.longVersion == "1.2.3.456")
        }
        
        @Test("Short version with missing components")
        func shortVersionWithMissingComponents() {
            let version = VersionString(rawValue: "5")
            
            #expect(version.shortVersion == "5.0.0")
        }
        
        @Test("Long version with missing build")
        func longVersionWithMissingBuild() {
            let version = VersionString(rawValue: "2.3.4")
            
            #expect(version.longVersion == "2.3.4.0")
        }
        
        @Test(
            "Various version formats produce correct outputs",
            arguments: [
                ("1.0.0.1", "1.0.0", "1.0.0.1"),
                ("2.5.7", "2.5.7", "2.5.7.0"),
                ("10.20.30.40", "10.20.30", "10.20.30.40"),
                ("3", "3.0.0", "3.0.0.0")
            ]
        )
        func variousVersionFormats(input: String, expectedShort: String, expectedLong: String) {
            let version = VersionString(rawValue: input)
            
            #expect(version.shortVersion == expectedShort)
            #expect(version.longVersion == expectedLong)
        }
    }
    
    // MARK: - Comparison Tests
    
    @Suite("Comparison Tests")
    struct ComparisonTests {
        
        @Test("Equal versions are equal")
        func equalVersions() {
            let version1 = VersionString(rawValue: "1.2.3.4")
            let version2 = VersionString(rawValue: "1.2.3.4")
            
            #expect(version1 == version2)
            #expect(!(version1 < version2))
            #expect(!(version1 > version2))
        }
        
        @Test("Major version comparison")
        func majorVersionComparison() {
            let lower = VersionString(rawValue: "1.0.0.0")
            let higher = VersionString(rawValue: "2.0.0.0")
            
            #expect(lower < higher)
            #expect(higher > lower)
            #expect(lower != higher)
        }
        
        @Test("Minor version comparison")
        func minorVersionComparison() {
            let lower = VersionString(rawValue: "1.5.0.0")
            let higher = VersionString(rawValue: "1.6.0.0")
            
            #expect(lower < higher)
            #expect(higher > lower)
        }
        
        @Test("Patch version comparison")
        func patchVersionComparison() {
            let lower = VersionString(rawValue: "1.0.3.0")
            let higher = VersionString(rawValue: "1.0.4.0")
            
            #expect(lower < higher)
            #expect(higher > lower)
        }
        
        @Test("Build version comparison")
        func buildVersionComparison() {
            let lower = VersionString(rawValue: "1.0.0.10")
            let higher = VersionString(rawValue: "1.0.0.20")
            
            #expect(lower < higher)
            #expect(higher > lower)
        }
        
        @Test("Multi-digit version comparison")
        func multiDigitVersionComparison() {
            let lower = VersionString(rawValue: "1.9.0.0")
            let higher = VersionString(rawValue: "1.10.0.0")
            
            #expect(lower < higher)
            #expect(higher > lower)
        }
        
        @Test("Version with missing components comparison")
        func missingComponentsComparison() {
            let version1 = VersionString(rawValue: "1.0")
            let version2 = VersionString(rawValue: "1.0.0.0")
            
            #expect(version1 != version2)
        }
        
        @Test(
            "Various version comparisons",
            arguments: [
                ("1.0.0", "2.0.0", true),
                ("1.5.0", "1.6.0", true),
                ("1.0.5", "1.0.6", true),
                ("1.0.0.5", "1.0.0.6", true),
                ("2.0.0", "1.9.9", false),
                ("1.10.0", "1.9.0", false),
                ("1.0.10", "1.0.9", false)
            ]
        )
        func variousComparisons(left: String, right: String, leftIsLess: Bool) {
            let leftVersion = VersionString(rawValue: left)
            let rightVersion = VersionString(rawValue: right)
            
            if leftIsLess {
                #expect(leftVersion < rightVersion)
                #expect(rightVersion > leftVersion)
            } else {
                #expect(leftVersion > rightVersion)
                #expect(rightVersion < leftVersion)
            }
        }
        
        @Test("Sorting versions")
        func sortingVersions() {
            let versions = [
                VersionString(rawValue: "2.0.0"),
                VersionString(rawValue: "1.0.0"),
                VersionString(rawValue: "1.5.0"),
                VersionString(rawValue: "1.0.5"),
                VersionString(rawValue: "3.0.0")
            ]
            
            let sorted = versions.sorted()
            
            #expect(sorted[0].rawValue == "1.0.0")
            #expect(sorted[1].rawValue == "1.0.5")
            #expect(sorted[2].rawValue == "1.5.0")
            #expect(sorted[3].rawValue == "2.0.0")
            #expect(sorted[4].rawValue == "3.0.0")
        }
    }
    
    // MARK: - CustomStringConvertible Tests
    
    @Suite("CustomStringConvertible Tests")
    struct StringConvertibleTests {
        
        @Test("Description format is correct")
        func descriptionFormat() {
            let version = VersionString(rawValue: "1.2.3.4")
            
            #expect(version.description == "v.1.2.3.4")
        }
        
        @Test(
            "Description format for various versions",
            arguments: [
                ("1.0.0.1", "v.1.0.0.1"),
                ("2.5.7", "v.2.5.7"),
                ("10.20.30.40", "v.10.20.30.40"),
                ("", "v.")
            ]
        )
        func descriptionForVariousVersions(input: String, expectedDescription: String) {
            let version = VersionString(rawValue: input)
            
            #expect(version.description == expectedDescription)
        }
        
        @Test("String interpolation uses description")
        func stringInterpolation() {
            let version = VersionString(rawValue: "1.2.3")
            let text = "Current version: \(version)"
            
            #expect(text == "Current version: v.1.2.3")
        }
    }
    
    // MARK: - Codable Tests
    
    @Suite("Codable Tests")
    struct CodableTests {
        
        @Test("Encode and decode version string")
        func encodeDecodeVersionString() throws {
            let original = VersionString(rawValue: "1.2.3.456")
            
            let encoder = JSONEncoder()
            let data = try encoder.encode(original)
            
            let decoder = JSONDecoder()
            let decoded = try decoder.decode(VersionString.self, from: data)
            
            #expect(decoded.rawValue == original.rawValue)
            #expect(decoded.major == original.major)
            #expect(decoded.minor == original.minor)
            #expect(decoded.patch == original.patch)
            #expect(decoded.build == original.build)
        }
        
        @Test("Decode from JSON string")
        func decodeFromJSON() throws {
            let json = """
            "2.5.7.100"
            """
            
            let data = json.data(using: .utf8)!
            let decoder = JSONDecoder()
            let version = try decoder.decode(VersionString.self, from: data)
            
            #expect(version.major == "2")
            #expect(version.minor == "5")
            #expect(version.patch == "7")
            #expect(version.build == "100")
        }
        
        @Test(
            "Encode and decode various version formats",
            arguments: [
                "1.0.0.1",
                "2.5.7",
                "10.20.30.40",
                "5",
                ""
            ]
        )
        func encodeDecodeVariousFormats(versionString: String) throws {
            let original = VersionString(rawValue: versionString)
            
            let encoder = JSONEncoder()
            let data = try encoder.encode(original)
            
            let decoder = JSONDecoder()
            let decoded = try decoder.decode(VersionString.self, from: data)
            
            #expect(decoded == original)
        }
    }
    
    // MARK: - RawRepresentable Tests
    
    @Suite("RawRepresentable Tests")
    struct RawRepresentableTests {
        
        @Test("Raw value is preserved")
        func rawValuePreserved() {
            let input = "1.2.3.456"
            let version = VersionString(rawValue: input)
            
            #expect(version.rawValue == input)
        }
        
        @Test("Can recreate from raw value")
        func recreateFromRawValue() {
            let original = VersionString(rawValue: "2.5.7.100")
            let recreated = VersionString(rawValue: original.rawValue)
            
            #expect(recreated.major == original.major)
            #expect(recreated.minor == original.minor)
            #expect(recreated.patch == original.patch)
            #expect(recreated.build == original.build)
        }
    }
    
    // MARK: - Edge Cases
    
    @Suite("Edge Cases")
    struct EdgeCaseTests {
        
        @Test("Version with leading zeros")
        func versionWithLeadingZeros() {
            let version = VersionString(rawValue: "01.02.03.04")
            
            #expect(version.major == "01")
            #expect(version.minor == "02")
            #expect(version.patch == "03")
            #expect(version.build == "04")
        }
        
        @Test("Version with very large numbers")
        func versionWithLargeNumbers() {
            let version = VersionString(rawValue: "999.999.999.9999")
            
            #expect(version.major == "999")
            #expect(version.minor == "999")
            #expect(version.patch == "999")
            #expect(version.build == "9999")
        }
        
        @Test("Comparison with leading zeros")
        func comparisonWithLeadingZeros() {
            let version1 = VersionString(rawValue: "1.0.0")
            let version2 = VersionString(rawValue: "01.00.00")
            
            // Numeric comparison dovrebbe considerarli uguali
            #expect(version1 == version2)
        }
        
        @Test("Version with extra components are ignored")
        func extraComponentsIgnored() {
            let version = VersionString(rawValue: "1.2.3.4.5.6")
            
            #expect(version.major == "1")
            #expect(version.minor == "2")
            #expect(version.patch == "3")
            #expect(version.build == "4")
        }
        
        @Test("Version with non-numeric characters")
        func versionWithNonNumericCharacters() {
            let version = VersionString(rawValue: "1.2.3-beta.456")
            
            // Il comportamento dipende dall'implementazione di split
            #expect(version.major == "1")
            #expect(version.minor == "2")
        }
    }
    
    // MARK: - Real World Scenarios
    
    @Suite("Real World Scenarios")
    struct RealWorldScenarioTests {
        
        @Test("iOS version comparison")
        func iOSVersionComparison() {
            let ios16 = VersionString(rawValue: "16.0.0")
            let ios17 = VersionString(rawValue: "17.0.0")
            let ios17_1 = VersionString(rawValue: "17.1.0")
            
            #expect(ios16 < ios17)
            #expect(ios17 < ios17_1)
            #expect(ios16 < ios17_1)
        }
        
        @Test("App version update detection")
        func appVersionUpdateDetection() {
            let currentVersion = VersionString(rawValue: "2.5.0.100")
            let availableVersion = VersionString(rawValue: "2.6.0.1")
            
            let updateAvailable = availableVersion > currentVersion
            
            #expect(updateAvailable == true)
        }
        
        @Test("Minimum version requirement check")
        func minimumVersionRequirement() {
            let minimumRequired = VersionString(rawValue: "3.0.0")
            let userVersion1 = VersionString(rawValue: "2.9.9")
            let userVersion2 = VersionString(rawValue: "3.0.0")
            let userVersion3 = VersionString(rawValue: "3.1.0")
            
            #expect(userVersion1 < minimumRequired)
            #expect(userVersion2 >= minimumRequired)
            #expect(userVersion3 >= minimumRequired)
        }
    }
}
