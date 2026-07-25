//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Pavel Strezh on 23.07.2026.
//

import UIKit

// Тут содержится метод для отображения Алерты c полученными результатами Квиза
class AlertPresenter: AlertPresenterProtocol {
    
    weak var delegate: AlertPresenterDelegate?
    
    // Метод отображения Алерты с результатами Квиза, полученными от делегата и уведомления Контролера о событии
    func show(viewController: UIViewController, with result: AlertModel?) {
        let alert = UIAlertController(
            title: result!.title,
            message: result!.message,
            preferredStyle: .alert
        )
        let action = UIAlertAction(
            title: result!.buttonText,
            style: .default
        ) {_ in
            result!.completion()
        }
        
        alert.addAction(action)
        viewController.present(alert, animated: true, completion: nil)
        
    }
    
    // Метод инициализации Делегата
    func didSetDelegate(_ delegate: AlertPresenterDelegate?) {
        self.delegate = delegate
    }
    
}

