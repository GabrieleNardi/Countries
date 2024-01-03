//
//  CoordinatesTests.swift
//
//
//  Created by Gabriele Nardi on 27/12/23.
//

import XCTest
@testable import DataModel

final class CoordinatesTests: XCTestCase {
    
    var coordinates: Country.Coordinates!
    
    override func setUp() {
        super.setUp()
        
            coordinates = Country.Coordinates(latitude: 42.83333333, longitude: 12.83333333)
    }
    
    override func tearDown() {
        super.tearDown()
        
        coordinates = nil
    }
    
    func test_init_coordinates_latitude() throws {
        XCTAssertEqual(coordinates.latitude, 42.83333333)
    }
    
    func test_init_coordinates_longitude() throws {
        XCTAssertEqual(coordinates.longitude, 12.83333333)
    }
}

