//
//  CountriesUITests.swift
//  CountriesUITests
//
//  Created by Gabriele Nardi on 29/12/23.
//

import XCTest

final class CountriesUITests: XCTestCase {

    func test_show_list() throws {
        let app = XCUIApplication()
        app.launchArguments.append("-ui-test")
        app.launch()
                
        let label = app.collectionViews.staticTexts["Albania"]
        let exists = NSPredicate(format: "exists == 1")
        
        let expectation = expectation(for: exists, evaluatedWith: label, handler: nil)
        wait(for: [expectation], timeout: 10)
    }
    
    func test_open_detail() throws {
        let app = XCUIApplication()
        app.launchArguments.append("-ui-test")
        app.launch()
                
        let cell = app.collectionViews.staticTexts["Albania"]
        while !cell.exists {
            app.swipeUp()
        }
        
        cell.tap()
        
        let exists = NSPredicate(format: "exists == 1")
        let label = app.collectionViews.staticTexts["Albania"]
        let expectation = expectation(for: exists, evaluatedWith: label, handler: nil)
        wait(for: [expectation], timeout: 10)
    }
}
