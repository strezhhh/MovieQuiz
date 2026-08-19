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
    let questionsAmount: Int = 10
    
    // MARK: - Methods
    
    // Метод проверяет является ли текущий вопрос последним
    func isLastQuestions() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    // Метод сбрасывает индекс вопросов на 0
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    // Метод увеличивает индекс вопросов на 1
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    // Метод конвертации из структуры вопроса во вью модель
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            // image: UIImage(data: model.imageData) ?? UIImage(), // старый код
            imageData: model.imageData, // рефакторинг
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)" // надо добавить эти две переменные
        )
    }
    
}
