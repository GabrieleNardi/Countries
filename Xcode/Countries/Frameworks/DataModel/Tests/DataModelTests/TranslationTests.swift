//
//  TranslationTests.swift
//
//
//  Created by Gabriele Nardi on 27/12/23.
//

import XCTest
@testable import DataModel

final class TranslationTests: XCTestCase {
    
    var translation: Country.Translation!
    
    override func setUp() {
        super.setUp()
        
            translation = Country.Translation(language: "ita", name: "Italia")
    }
    
    override func tearDown() {
        super.tearDown()
        
        translation = nil
    }
    
    func test_init_coordinates_latitude() throws {
        XCTAssertEqual(translation.language, "ita")
    }
    
    func test_init_coordinates_longitude() throws {
        XCTAssertEqual(translation.name, "Italia")
    }
}

