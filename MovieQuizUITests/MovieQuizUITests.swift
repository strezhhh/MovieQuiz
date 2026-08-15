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
        
        sleep(3)
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        // XCTAssertTrue(firstPoster.exists) // это лишнее, так как мы проверяем побайтово два скрина
        sleep(10)
        // вот тут отключал интернет и тест проходил без ошибок
        app.buttons["Yes"].tap()
        sleep(3)
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        XCTAssertTrue(secondPoster.exists)
        XCTAssertNotEqual(firstPosterData, secondPosterData)
    }

    func testNoButton() {
        sleep(3)
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        app.buttons["No"].tap()
        sleep(3)
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        XCTAssertNotEqual(firstPosterData, secondPosterData)
    }
    
//    func testIndexLabel() {
//        let indexLabel = app.staticTexts["Index"]
//        XCTAssertEqual(indexLabel.label, "2/10")
//    }
    
    
    
}
