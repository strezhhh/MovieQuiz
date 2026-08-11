//
//  MoviesLoader.swift
//  MovieQuiz
//
//  Created by Pavel Strezh on 10.08.2026.
//

import Foundation

// Загрузчик реализующий протокол MoviesLoading
struct MoviesLoader: MoviesLoading {
    
    // MARK: - NetworkClient
    //private var networkClient: NetworkClient()
    
    // MARK: - URL
    //    private var mostPopularMoviesUrl: URL {
    //        // Если мы не смогли преобразовать строку в URL, то приложение упадёт с ошибкой
    //        guard let url = URL(string: "https://tv-api.com/en/API/Top250Movies/k_j4r66gt6") else {
    //                    preconditionFailure("Unable to construct mostPopularMoviesUrl")
    //                }
    //                return url
    //            }
    //    }
    
    // MARK: - Methods
    // Метод преобразует полученную от networkClient Data в MostPopularMovies
    // Инициализируется в QuestionFactory
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        
        let networkClient = NetworkClient()
        var mostPopularMoviesUrl: URL {
            
            // Если мы не смогли преобразовать строку в URL, то приложение упадёт с ошибкой, так как это проблема кода
            guard let url = URL(string: "https://tv-api.com/en/API/MostPopularTVs/k_j4r66gt6") else {
                preconditionFailure("Unable to construct mostPopularMoviesUrl")
            }
            return url
        }
        
        networkClient.fetch(url: mostPopularMoviesUrl) { result in
            switch result {
            case .success(let data):
                do {
                    let mostPopularMovies = try JSONDecoder().decode(MostPopularMovies.self, from: data)
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
