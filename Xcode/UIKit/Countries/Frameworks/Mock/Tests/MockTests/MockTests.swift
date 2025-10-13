import XCTest
import DataModel
@testable import Mock

final class MockTests: XCTestCase {
    
    func test_mock_country_notEmpty() throws {
        XCTAssertNotEqual(Country.mockValues, [])
    }
    
    func test_allCountries_decode_performance() throws {
        measure(metrics: [XCTMemoryMetric(), XCTClockMetric(), XCTCPUMetric()]) {
            _ = Country.mockValues
        }
    }
    
    func test_mock_pexelsImage_notEmpty() throws {
        XCTAssertNotEqual(PexelsImage.mockValues, [])
    }
    
    func test_allPexelsImage_decode_performance() throws {
        measure(metrics: [XCTMemoryMetric(), XCTClockMetric(), XCTCPUMetric()]) {
            _ = PexelsImage.mockValues
        }
    }
}
