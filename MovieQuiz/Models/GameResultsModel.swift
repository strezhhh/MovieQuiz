//
//  GameResultsModel.swift
//  MovieQuiz
//
//  Created by Pavel Strezh on 28.07.2026.
//

import UIKit

// Структура лучшего результата Квиза, которую будем сохранять в UserDefaults
struct GameResult {
    let correct: Int
    let total: Int
    let date: Date
    
    // Метод сравнения по количеству верных ответов
    func isBetterThan(_ another: GameResult) -> Bool {
        correct > another.correct
    }
}
