//
//  AlertModelDelegate.swift
//  MovieQuiz
//
//  Created by Pavel Strezh on 23.07.2026.
//

import UIKit

// Класс реализующий этот протокол может быть Делегатом у сущности
//  отображающей Алерту и реализующей протокол AlertModelProtocol
protocol AlertPresenterDelegate: AnyObject {
    // метод, который вызовет делегатор, чтобы сообщить, что юзер проинформирован и нажал кнопку
    func didShowAlert()
}
