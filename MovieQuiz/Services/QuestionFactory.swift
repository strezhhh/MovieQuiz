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
    
    // MARK: - Delegates
    
    weak var delegate: QuestionFactoryDelegate?
    
    // MARK: - Init Method
    
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate?) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
    // MARK: - Methods

    // Метод генерации следующего мокового вопроса
    func requestNextQuestion() {
        // рандомно выбираем один из вопросов
        guard let index = (0..<questions.count).randomElement() else {
            delegate?.didReceiveNextQuestion(question: nil)
            return
        }
        let questions = questions[safe: index]
        delegate?.didReceiveNextQuestion(question: questions)
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

