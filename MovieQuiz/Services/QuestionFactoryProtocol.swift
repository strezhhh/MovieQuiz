//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Pavel Strezh on 19.07.2026.
//

import Foundation

// Объект реализующий этот протокол, может использоваться как фабрика вопросов.
protocol QuestionFactoryProtocol {
    func requestNextQuestion()
    func didSetDelegate(_ delegate: QuestionFactoryDelegate?)
}
