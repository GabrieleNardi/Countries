//
//  PexelsImageTests.swift
//  
//
//  Created by Gabriele Nardi on 27/12/23.
//

import XCTest
@testable import DataModel

final class PexelsImageTests: XCTestCase {
    
    var pexelsImage: PexelsImage!

    override func setUp() {
        super.setUp()
        
        pexelsImage = PexelsImage(imageUrl: URL(string: "https://images.pexels.com/photos/629142/pexels-photo-629142.jpeg?auto=compress&cs=tinysrgb&h=350"), credits: "Lorenzo Pacifico")
    }
    
    override func tearDown() {
        super.tearDown()
        
        pexelsImage = nil
    }
    
    func test_init_imageUrl() {
        XCTAssertEqual(pexelsImage.imageUrl?.absoluteString, "https://images.pexels.com/photos/629142/pexels-photo-629142.jpeg?auto=compress&cs=tinysrgb&h=350")
    }
    
    func test_init_credits() {
        XCTAssertEqual(pexelsImage.credits, "Lorenzo Pacifico")
    }
    
    func test_decode_imageUrl() throws {
        let pexelsImage: PexelsImage = try getDecodableFromJSON(name: "PexelsImage")
        
        XCTAssertEqual(pexelsImage.imageUrl?.absoluteString, "https://images.pexels.com/photos/629142/pexels-photo-629142.jpeg?auto=compress&cs=tinysrgb&h=350")
    }
    
    func test_decode_credits() throws {
        let pexelsImage: PexelsImage = try getDecodableFromJSON(name: "PexelsImage")
        
        XCTAssertEqual(pexelsImage.credits, "Lorenzo Pacifico")
    }
    
    func test_decode_performance() throws {
        measure(metrics: [XCTClockMetric(), XCTMemoryMetric()]) {
            do {
                let _: PexelsImage = try getDecodableFromJSON(name: "PexelsImage")
            } catch {
                print("PexelsImageTestError:", error)
            }
        }
    }
}
