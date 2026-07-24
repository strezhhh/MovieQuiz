//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Pavel Strezh on 23.07.2026.
//

import UIKit

// Тут содержится метод для отображения Алерты c полученными результатами Квиза
class AlertPresenter: AlertModelProtocol {
    
    weak var delegate: AlertModelDelegate?
    
    private var alertModel: AlertModel?
    
    // Метод отображения Алерты с результатами Квиза, полученными от делегата и уведомления Контролера о событии
    func showAlert(quizResult: AlertModel?) {
        guard let quizResult else { return }
        let alert = UIAlertController(
            title: quizResult.title,
            message: quizResult.message,
            preferredStyle: .alert
        )
        let action = UIAlertAction(
            title: quizResult.buttonText,
            style: .default
        )
//            )  { [weak self] _ in // это слабая ссылка на self
//                guard let self = self else { return } // разворачиваем self
//                self.currentQuestionIndex = 0
//                self.correctAnswers = 0
//                questionFactory?.requestNextQuestion()
//                self.hideBorder()
//            }
        alert.addAction(action)
        //self.present(alert, animated: true, quizResult.completion: nil)

    }
    

            
//            let quizResults = QuizResultsViewModel (
//                title: "Этот раунд окончен!",
//                text: "Ваш результат: \(correctAnswers)/\(questionsAmount)",
//                buttonText: "Сыграть еще раз"
//            )


        
//        private func show(quiz result: QuizResultsViewModel) {
//            let alert = UIAlertController(
//                title: result.title,
//                message: result.text,
//                preferredStyle: .alert
//            )
//            let action = UIAlertAction(
//                title: result.buttonText,
//                style: .default
//            ) { [weak self] _ in // это слабая ссылка на self
//                guard let self = self else { return } // разворачиваем self
//                self.currentQuestionIndex = 0
//                self.correctAnswers = 0
//                questionFactory?.requestNextQuestion()
//                self.hideBorder()
//                
//            }
//            alert.addAction(action)
//            self.present(alert, animated: true, completion: nil)
//        }

    
    
    // Метод инициализации Делегата
    func didSetDelegateForAlertPresenter(_ delegate: AlertModelDelegate?) {
        self.delegate = delegate
    }
}

