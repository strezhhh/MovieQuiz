//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Pavel Strezh on 23.07.2026.
//

import UIKit

// Тут содержится метод для отображения Алерты c полученными результатами Квиза
final class AlertPresenter: AlertPresenterProtocol {
    
    weak var delegate: AlertPresenterDelegate?
    
    // Метод отображения Алерты с результатами Квиза, полученными от делегата и уведомления Контролера о событии
    func showAlertWithResult(viewController: UIViewController, with result: AlertModel?) {
        guard let result else { return }
        let alert = UIAlertController(
            title: result.title,
            message: result.message,
            preferredStyle: .alert
        )
        let action = UIAlertAction(
            title: result.buttonText,
            style: .default
        ) {_ in
            result.completion()
        }
        
        alert.addAction(action)
        DispatchQueue.main.async {
            viewController.present(alert, animated: true, completion: nil)
        }
        
    }
    
    // Метод инициализации Делегата
    func didSetDelegate(_ delegate: AlertPresenterDelegate?) {
        self.delegate = delegate
    }
    
}

