//
//  MoviesLoader.swift
//  MovieQuiz
//
//  Created by Pavel Strezh on 10.08.2026.
//

import Foundation

// протокол для загрузчика фильмов
protocol MoviesLoading {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}

// Загрузчик реализующий протокол MoviesLoading
struct MoviesLoader: MoviesLoading {
    
    // MARK: - NetworkClient
    private var networkClient: NetworkClient()
    
    // MARK: - URL
    private var mostPopularMoviesUrl: URL {
        // Если мы не смогли преобразовать строку в URL, то приложение упадёт с ошибкой
        guard let url = URL(string: "https://tv-api.com/en/API/Top250Movies/k_j4r66gt6") else {
                    preconditionFailure("Unable to construct mostPopularMoviesUrl")
                }
                return url
            }

    }
    // networkClient, mostPopularMoviesUrl
    
    
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        
    }
}


