//
//  CurrencyTests.swift
//
//
//  Created by Gabriele Nardi on 27/12/23.
//

import XCTest
@testable import DataModel

final class CurrencyTests: XCTestCase {
    
    var currency: Country.Currency!
    
    override func setUp() {
        super.setUp()
        
            currency = Country.Currency(name: "Euro", symbol: "€")
    }
    
    override func tearDown() {
        super.tearDown()
        
        currency = nil
    }
    
    func test_init_coordinates_latitude() throws {
        XCTAssertEqual(currency.name, "Euro")
    }
    
    func test_init_coordinates_longitude() throws {
        XCTAssertEqual(currency.symbol, "€")
    }
}

