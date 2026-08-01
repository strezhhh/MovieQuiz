//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Pavel Strezh on 28.07.2026.
//

import UIKit

// Сервис работы с UserDefaults
final class StatisticService: StatisticServiceProtocol {
    
    // MARK: - Private enumeration
    
    private enum Keys: String {
        case gamesCount          // Для счётчика сыгранных игр
        case bestGameCorrect     // Для количества правильных ответов в лучшей игре
        case bestGameTotal       // Для общего количества вопросов в лучшей игре
        case bestGameDate        // Для даты лучшей игры
        case totalCorrectAnswers // Для общего количества правильных ответов за все игры
        case totalQuestionsAsked // Для общего количества вопросов, заданных за все игры
    }
    
    // MARK: - Private properties
    
    private let storage: UserDefaults = .standard
    
    // общее количество всех правильных ответов. Каждую игру обновляем данные по запросу
    private var totalCorrectAnswers: Int {
        get {
            storage.integer(forKey: "\(Keys.totalCorrectAnswers.rawValue)")
        }
        set {
            let value = storage.integer(forKey: "totalCorrectAnswers") + newValue
            storage.set(value, forKey: "\(Keys.totalCorrectAnswers.rawValue)")
        }
    }
    
    // общее количество всех заданных вопросов. Каждую игру обновляем данные по запросу
    private var totalQuestionsAsked: Int {
        get {
            storage.integer(forKey: "\(Keys.totalQuestionsAsked.rawValue)")
        }
        set {
            storage.set(storage.integer(forKey: "gamesCount") * 10, forKey: "\(Keys.totalQuestionsAsked.rawValue)")
            
        }
    }
    
    
    // MARK: - Properties
    
    // Количество сыгранных Квизов
    var gamesCount: Int {
        get {
            storage.integer(forKey: "\(Keys.gamesCount.rawValue)")
        }
        set {
            storage.set(newValue, forKey: "\(Keys.gamesCount.rawValue)")
        }
    }
    
    // Кол-во правильных ответов, кол-ва вопросов, дата лучшей игры
    var bestGame: GameResult {
        get { GameResult (
            correct: storage.integer(forKey: "\(Keys.bestGameCorrect)"),
            total: storage.integer(forKey: "\(Keys.bestGameTotal)"),
            date: storage.object(forKey: "\(Keys.bestGameDate)") as? Date ?? Date()
        )
        }
        set {
            storage.set(newValue.correct, forKey: "\(Keys.bestGameCorrect)")
            storage.set(newValue.total, forKey: "\(Keys.bestGameTotal)")
            storage.set(newValue.date, forKey: "\(Keys.bestGameDate)")
        }
    }
    
    // отношение общего числа правильных ответов ко всем заданным вопросам за все игры
    var totalAccuracy: Double {
        if storage.integer(forKey: "\(Keys.totalQuestionsAsked)") == 0 {
            return 0
        } else {
            return (round(100 * (Double(storage.integer(forKey: "\(Keys.totalCorrectAnswers)")) / Double(storage.integer(forKey: "\(Keys.totalQuestionsAsked)")) * 100)) / 100)
        }
    }
    
    // MARK: - Private methods
    
    private func updateStore(correct: Int, total: Int) {
        // Увеличиваем количество игр на одну
        gamesCount += 1
        
        // Увеличиваем количество верных ответов и общее число вопросов
        totalCorrectAnswers = correct
        totalQuestionsAsked = total
        
        // Проверяем это самая первая игра в истории или нет,
        // если да, то прописываем нулевые значения для bestGame,
        // с которым сравним результаты текущей игры
        if gamesCount == 1 {
            bestGame = GameResult (
                correct: -1, // Устанавливаем -1, чтобы 0 правильных ответов в самой первой игре оказался точно больше при проверке количества корректных ответов
                total: 0,
                date: Date()
            )
        }
    }
    
    
    // MARK: - Methods
    
    func store(correct count: Int, total amount: Int) {
        updateStore(correct: count, total: amount)
        
        let currentGame = GameResult (
            correct: count,
            total: amount,
            date: Date()
        )
        if currentGame.isBetterThan(bestGame) {
            bestGame = currentGame
        }
    }
    
}




