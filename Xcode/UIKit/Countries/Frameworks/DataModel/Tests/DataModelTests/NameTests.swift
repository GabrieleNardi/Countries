//
//  NameTests.swift
//
//
//  Created by Gabriele Nardi on 27/12/23.
//

import XCTest
@testable import DataModel

final class NameTests: XCTestCase {
    
    // MARK: - Properties
    
    var countryName: Country.Name!
    
    // MARK: - XCTestCase methods
    
    override func setUp() {
        super.setUp()
        
            countryName = Country.Name(
                common: "Italy",
                official: "Italian Republic"
            )
    }
    
    override func tearDown() {
        super.tearDown()
        
        countryName = nil
    }
    
    // MARK: - Tests methods
    
    func test_init_name_common() throws {
        XCTAssertEqual(countryName.common, "Italy")
    }
    
    func test_init_name_official() throws {
        XCTAssertEqual(countryName.official, "Italian Republic")
    }
    
    func test_decode_name_common() throws {
        let name: Country.Name = try getDecodableFromJSON(name: "Name")
        
        XCTAssertEqual(name.common, "British Indian Ocean Territory")
    }
    
    func test_decode_name_official() throws {
        let name: Country.Name = try getDecodableFromJSON(name: "Name")
        
        XCTAssertEqual(name.common, "British Indian Ocean Territory")
    }
    
    func test_decode_performance()  {
        measure(metrics: [XCTClockMetric(), XCTMemoryMetric()]) {
            do {
                let _: Country.Name = try getDecodableFromJSON(name: "Name")
            } catch {
                print("NameTestError:", error)
            }
        }
    }
}

