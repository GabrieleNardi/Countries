import Testing
@testable import Commons

@Suite("Device tests")
struct DeviceTests {
    
    @Test("isTests is true in test environment")
    func isTestsTrue() async throws {
        #expect(Device.main.isTests == true)
    }
    
    @Test("isRunningOnSimulator matches targetEnvironment(simulator)")
    func simulatorFlagMatches() async throws {
        #if targetEnvironment(simulator)
        #expect(Device.main.isRunningOnSimulator == true)
        #else
        #expect(Device.main.isRunningOnSimulator == false)
        #endif
    }
    
    @Test("distribution is .xcTests during tests")
    func distributionIsXcTests() async throws {
        let dist = await Device.main.distribution
        #expect(dist == .xcTests)
    }
    
    @Test("isDebug is true during tests")
    func isDebugTrueDuringTests() async throws {
        let isDebug = await Device.main.isDebug
        #expect(isDebug == true)
    }
    
    @Test("appVersion has plausible semantic version with build")
    func appVersionFormat() async throws {
        let pattern = #"^\d+\.\d+\.\d+\.\d+$"#
        let validSamples = [
            "1.0.0.1",
            "16.2.3.456",
            "0.0.1.0"
        ]
        let invalidSamples = [
            "16.0.24256",
            "1.0",
            "1.0.0",
            "1.0.0.",
            "a.b.c.d"
        ]
        for s in validSamples {
            let matches = s.range(of: pattern, options: .regularExpression) != nil
            #expect(matches, "Expected valid sample to match x.y.z.build: \(s)")
        }
        for s in invalidSamples {
            let matches = s.range(of: pattern, options: .regularExpression) != nil
            #expect(matches == false, "Expected invalid sample NOT to match x.y.z.build: \(s)")
        }
    }
    
    @Test("Distribution description strings are correct")
    func distributionDescriptions() async throws {
        #expect(Device.Distribution.xcTests.description == "xctests")
        #expect(Device.Distribution.testFlight.description == "testflight")
        #expect(Device.Distribution.appStore.description == "appstore")
        #expect(Device.Distribution.xCodeDebug.description == "xcode")
    }
}

