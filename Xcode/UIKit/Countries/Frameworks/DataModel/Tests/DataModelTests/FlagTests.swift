//
//  FlagTests.swift
//
//
//  Created by Gabriele Nardi on 27/12/23.
//

import XCTest
@testable import DataModel

final class FlagTests: XCTestCase {
    
    var flag: Country.Flag!
    
    override func setUp() {
        super.setUp()
        
        flag = Country.Flag(url: URL(string: "https://flagcdn.com/w320/it.png"))
    }
    
    override func tearDown() {
        super.tearDown()
        
        flag = nil
    }
    
    func test_init_flag_url() throws {
        XCTAssertEqual(flag.url?.absoluteString, "https://flagcdn.com/w320/it.png")
    }
    
    func test_decode_flag_url() throws {
        let flag: Country.Flag = try getDecodableFromJSON(name: "Flag")
        
        XCTAssertEqual(flag.url?.absoluteString, "https://flagcdn.com/w320/io.png")
    }
    
    func test_decode_performance()  {
        measure(metrics: [XCTClockMetric(), XCTMemoryMetric()]) {
            do {
                let _: Country.Flag = try getDecodableFromJSON(name: "Flag")
            } catch {
                print("FlagTestError:", error)
            }
        }
    }
}
