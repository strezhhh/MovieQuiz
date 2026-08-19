//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Pavel Strezh on 19.08.2026.
//

import Foundation

final class MovieQuizPresenter {
    
    // MARK: - Properties
    
    // Слабая ссылка на MovieQuizViewController
    weak var viewController: MovieQuizViewController?
    
    // Переменная с индексом текущего вопроса
    private var currentQuestionIndex: Int = 0
    
    // Общее количество вопросов для Квиза
    let questionsAmount: Int = 10
    
    // Вопрос который видит пользователь
    var currentQuestion: QuizQuestion?
    
    // MARK: - Methods
    
    // Метод вызывается когда юзер нажимает кнопку "Да"
    func didTapYesButton() {
        didAnswer (guess: true)
    }
    
    // Метод вызывается когда юзер нажимает кнопку "Нет"
    func didTapNoButton() {
        didAnswer (guess: false)
    }
    
    // Метод сравнивает полученный от пользователя ответ с правильным
    private func didAnswer (guess: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        viewController?.showAnswerResult(isCorrect: guess == currentQuestion.correctAnswer)
    }
    
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
