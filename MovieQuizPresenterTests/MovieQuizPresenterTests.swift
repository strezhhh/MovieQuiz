//
//  MovieQuizPresenterTests.swift
//  MovieQuizPresenterTests
//
//  Created by Pavel Strezh on 20.08.2026.
//

import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    
    func show(quiz step: QuizStepViewModel) {
        
    }
    func showBorder(answer: Bool) {
        
    }
    func hideBorder() {
        
    }
    func setButtonsIsEnabled(to newStatus: Bool) {
        
    }
    func showLoadingIndicator() {
        
    }
    func hideLoadingIndicator() {
        
    }
    func showNetworkError(title: String, message: String) {
        
    }
}

final class MovieQuizPresenterTests: XCTestCase {
    func testPresenterConvertModel() throws {
        let viewControllerMock = MovieQuizViewControllerMock()
        let sut = MovieQuizPresenter()
        sut.viewController = viewControllerMock
        
        let emptyData = Data()
        let question = QuizQuestion(imageData: emptyData, text: "Question Text", correctAnswer: true)
        let viewModel = sut.convert(model: question)
        
        XCTAssertEqual(viewModel.imageData, emptyData)
        XCTAssertEqual(viewModel.question, "Question Text")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
}

