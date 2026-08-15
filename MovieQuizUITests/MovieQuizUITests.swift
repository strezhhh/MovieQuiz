//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Pavel Strezh on 15.08.2026.
//

import XCTest

final class MovieQuizUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app = XCUIApplication()
        continueAfterFailure = false
        
        app.launch() // Вот этой строчки кода нет в теории, пришлось спросить ии-ку

    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        app.terminate()
        app = nil
    }

    func testYesButton() {
        let firstPoster = app.images["Poster"]
        app.buttons["Yes"].tap()
        let secondPoster = app.images["Poster"]
        XCTAssertFalse(firstPoster == secondPoster)
    }

    
    
}
