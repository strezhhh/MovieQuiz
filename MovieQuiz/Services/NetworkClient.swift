//
//  NetworkClient.swift
//  MovieQuiz
//
//  Created by Pavel Strezh on 09.08.2026.
//

import Foundation

/// Отвечает за загрузку данных по URL
struct NetworkClient {
    
    // MARK: - Private Enumeration
    private enum NetworkError: Error {
        case codeError
    }
    
    // MARK: - Methods
    // Функция запроса по заданному URL с API IMDb. Тип GET
    // Функция отдает результат асинхронно через handler
    // Метод инициируется MoviesLoader'ом
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void) {
        
        let request = URLRequest(url: url)
        let conf = URLSessionConfiguration.default
        conf.timeoutIntervalForRequest = 10
        let task = URLSession(configuration: conf).dataTask(with: request) { data, response, error in
            if let error {
                handler(.failure(error))
                return
            }
            
            if let response = response as? HTTPURLResponse,
               response.statusCode < 200 || response.statusCode >= 300 {
                handler(.failure(NetworkError.codeError))
                return
            }
            
            guard let data = data else {
                return }
            handler(.success(data))
        }
        
        task.resume()
    }
}
