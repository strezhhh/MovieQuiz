//
//  MoviesLoaderProtocol.swift
//  MovieQuiz
//
//  Created by Pavel Strezh on 11.08.2026.
//

import Foundation

// протокол для загрузчика фильмов
protocol MoviesLoading {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}
