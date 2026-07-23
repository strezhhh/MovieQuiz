//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Pavel Strezh on 19.07.2026.
//

import Foundation

// Тут храниться массив с вопросами и один метод, который возвращает случайно выбранный вопрос
class QuestionFactory: QuestionFactoryProtocol {
    // Массив моковых вопросов
    private let questions: [QuizQuestion] = [
        QuizQuestion(
            imageName: "The Godfather",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            imageName: "The Dark Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            imageName: "Kill Bill",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            imageName: "The Avengers",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            imageName: "Deadpool",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            imageName: "The Green Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            imageName: "Old",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            imageName: "The Ice Age Adventures of Buck Wild",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            imageName: "Tesla",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            imageName: "Vivarium",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false)
    ]
    
    // MARK: - Delegates
    
    weak var delegate: QuestionFactoryDelegate?
    
    // MARK: - Methods

    func requestNextQuestion() {
        // рандомно выбираем один из вопросов
        guard let index = (0..<questions.count).randomElement() else {
            delegate?.didReceiveNextQuestion(question: nil)
            return
        }
        let questions = questions[safe: index]
        delegate?.didReceiveNextQuestion(question: questions)
    }
    
    func didSetDelegate(_ delegate: QuestionFactoryDelegate?) {
        self.delegate = delegate
    }
    
    
}

