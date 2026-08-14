//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Pavel Strezh on 19.07.2026.
//

import UIKit
import Logging

// Тут храниться массив с вопросами и один метод, который возвращает случайно выбранный вопрос
final class QuestionFactory: QuestionFactoryProtocol {
    
    // MARK: - Properties
    
    private let moviesLoader: MoviesLoading
    private var movies: [MostPopularMovie] = []

    private let logger = Logger(label: "MovieQuiz")
    
    // Массив моковых вопросов
    // private let questions: [QuizQuestion] = [
        //            QuizQuestion(
        //                imageName: "The Godfather",
        //                text: "Рейтинг этого фильма больше чем 6?",
        //                correctAnswer: true),
        //
        //            QuizQuestion(
        //                imageName: "The Dark Knight",
        //                text: "Рейтинг этого фильма больше чем 6?",
        //                correctAnswer: true),
        //
        //            QuizQuestion(
        //                imageName: "Kill Bill",
        //                text: "Рейтинг этого фильма больше чем 6?",
        //                correctAnswer: true),
        //
        //            QuizQuestion(
        //                imageName: "The Avengers",
        //                text: "Рейтинг этого фильма больше чем 6?",
        //                correctAnswer: true),
        //
        //            QuizQuestion(
        //                imageName: "Deadpool",
        //                text: "Рейтинг этого фильма больше чем 6?",
        //                correctAnswer: true),
        //
        //            QuizQuestion(
        //                imageName: "The Green Knight",
        //                text: "Рейтинг этого фильма больше чем 6?",
        //                correctAnswer: true),
        //
        //            QuizQuestion(
        //                imageName: "Old",
        //                text: "Рейтинг этого фильма больше чем 6?",
        //                correctAnswer: false),
        //
        //            QuizQuestion(
        //                imageName: "The Ice Age Adventures of Buck Wild",
        //                text: "Рейтинг этого фильма больше чем 6?",
        //                correctAnswer: false),
        //
        //            QuizQuestion(
        //                imageName: "Tesla",
        //                text: "Рейтинг этого фильма больше чем 6?",
        //                correctAnswer: false),
        //
        //            QuizQuestion(
        //                imageName: "Vivarium",
        //                text: "Рейтинг этого фильма больше чем 6?",
        //                correctAnswer: false)
        //    ]
    
    // MARK: - Delegates
    
    weak var delegate: QuestionFactoryDelegate?
    
    // MARK: - Init Method
    
    init(moviesLoader: MoviesLoading) {
        self.moviesLoader = moviesLoader
    }
    
    // MARK: - Methods
    
    // Метод генерации следующего вопроса используя данные полученные из сети
    func requestNextQuestion() {
        
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            
            let index = (0..<self.movies.count).randomElement() ?? 0
            
            guard let movie = self.movies[safe: index] else { return }
            
            var imageData = Data()
            do {
                imageData = try Data(contentsOf: movie.resizedImageURL)
                // Проверяем, что данные это картинка
                guard UIImage(data: imageData) != nil else {
                    print("Данные не картинка")
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        self.delegate?.didFailToLoadImage()
                    }
                    return
                }
            } catch {
                print("нет данных")
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    logger.error("Failed to load image", metadata: ["error": "\(error)"])
                    self.delegate?.didFailToLoadImage()
                }
                return
            }

            let rating = Float(movie.rating ?? "0") ?? 0

            let rank = Int.random(in: (7...9))
            let text = "Рейтинг этого фильма больше чем \(rank)?"
            let correctAnswer = rating > Float(rank)
            
            let question = QuizQuestion(
                imageData: imageData,
                text: text,
                correctAnswer: correctAnswer
            )
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.didReceiveNextQuestion(question: question)
            }
            print("Отправляем следующий вопрос на отображение")
        }
    }
    
    // Метод инициализации делегата
    func didSetDelegate(_ delegate: QuestionFactoryDelegate?) {
        self.delegate = delegate
    }
    
    // Метод инициирует загрузку данных по сети
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
    
}

