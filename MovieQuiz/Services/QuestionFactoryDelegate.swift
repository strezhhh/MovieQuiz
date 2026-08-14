//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Pavel Strezh on 23.07.2026.
//

import Foundation

// Класс реализующий этот протокол может быть Делегатом у QuestionFactory
protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer() // сообщение об успешной загрузке
    func didFailToLoadData(with error: Error) // Ошибка! сообщение об ошибке загрузки с кодом ошибки
    func didFailToLoadImage() // Ошибка! Постер фильма нельзя отобразить
}
