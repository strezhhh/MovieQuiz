//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Pavel Strezh on 19.08.2026.
//

import Foundation

final class MovieQuizPresenter {
    
    // MARK: - Properties
    
    // Переменная с индексом текущего вопроса
    private var currentQuestionIndex: Int = 0
    
    // Общее количество вопросов для Квиза
    private let questionsAmount: Int = 10
    
    // MARK: - Private Methods
    
    // Метод конвертации из структуры вопроса во вью модель
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            // image: UIImage(data: model.imageData) ?? UIImage(), // старый код
            imageData: model.imageData, // рефакторинг
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)" // надо добавить эти две переменные
        )
    }
    
}
