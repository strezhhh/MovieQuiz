//
//  MoviesLoader.swift
//  MovieQuiz
//
//  Created by Pavel Strezh on 10.08.2026.
//

import Foundation

// Загрузчик фильмов реализующий протокол MoviesLoading
struct MoviesLoader: MoviesLoading {
    
    // MARK: - private Properties
    private let decoder = JSONDecoder()
    
    // MARK: - Methods
    // Метод преобразует полученную от networkClient Data в MostPopularMovies
    // Инициализируется в QuestionFactory
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        
        let networkClient = NetworkClient()
        var mostPopularMoviesUrl: URL {
            guard let url = URL(string: "https://tv-api.com/en/API/MostPopularTVs/k_j4r66gt6") else {
                preconditionFailure("Unable to construct mostPopularMoviesUrl")
            }
            return url
        }
        
        networkClient.fetch(url: mostPopularMoviesUrl) { result in
            switch result {
            case .success(let data):
                do {
                    let mostPopularMovies = try decoder.decode(MostPopularMovies.self, from: data)
                    handler(.success(mostPopularMovies))
                } catch {
                    handler(.failure(error))
                }
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
    
    
}
