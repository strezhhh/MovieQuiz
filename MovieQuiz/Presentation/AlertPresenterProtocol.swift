//
//  AlertModelProtocol.swift
//  MovieQuiz
//
//  Created by Pavel Strezh on 23.07.2026.
//

import UIKit

// Сущность реализующая этот протокол может быть использована для отображения Алерты.
protocol AlertPresenterProtocol {
    
    // Метод вызова Алерты
    func showAlert(viewController: UIViewController, with result: AlertModel?)
    
    // Метод инициализации делегата
    func didSetDelegate(_ delegate: AlertPresenterDelegate?)
    
}
