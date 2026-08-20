//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Pavel Strezh on 20.08.2026.
//

import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
        func show(quiz step: QuizStepViewModel)
        func showBorder(answer: Bool)
        func hideBorder()
        func setButtonsIsEnabled(to newStatus: Bool)
        func showLoadingIndicator()
        func hideLoadingIndicator()
        func showNetworkError(title: String, message: String)
}
