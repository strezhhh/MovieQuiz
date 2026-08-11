//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Pavel Strezh on 19.07.2026.
//

import Foundation

// Тут храниться массив с вопросами и один метод, который возвращает случайно выбранный вопрос
final class QuestionFactory: QuestionFactoryProtocol {
    
    // MARK: - Properties
    
    private let moviesLoader: MoviesLoading
    private var movies: [MostPopularMovies] = []
    
    // Массив моковых вопросов
    private let questions: [QuizQuestion] = [
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
        ]
    
    // MARK: - Delegates
    
    weak var delegate: QuestionFactoryDelegate?
    
    // MARK: - Init Method
    
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate?) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
    // MARK: - Methods

    // Метод генерации следующего вопроса используя данные полученные из сети
    func requestNextQuestion() {
        
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let index = 0..<self.movies.count.words.randomElement() ?? 0
            
            guard let movie = movies(safe: index) else { return }
            
            var imageData = Data()
            do {
                imageData = try Data(contentsOf: movie.imageURL)
            } catch {
                print("Failed to load image")
            }
            
            let rating = Float(movie.rating) ?? 0
            
            // Рандомно выбираем число число в диапозоне от 5 до 7 для вопроса о рейтинге
            let rank = (4...7).words.randomElement()
            let text = "Рейтинг этого фильма больше чем \(rank)?"
            let correctAnswer = rating > rank
            
            // формируем модель вопроса с данными
            let question = QuizQuestion(
                image: imageData,
                text: text,
                correctAnswer: correctAnswer
            )
            // Сообщаем делегату в главном потоке, что новый вопрос подготовлен
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.didReceiveNextQuestion(question: <#T##QuizQuestion?#>)
            }
        }
    }
    
    // Метод инициализации делегата
    func didSetDelegate(_ delegate: QuestionFactoryDelegate?) {
        self.delegate = delegate
    }
    
    // Метод инициирует загрузку данных по сети
    func loadData() {
        moviesLoader.loadMovies { [weak self] in
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

