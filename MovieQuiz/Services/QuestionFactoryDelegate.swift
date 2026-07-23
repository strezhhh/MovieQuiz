//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Pavel Strezh on 23.07.2026.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
}
