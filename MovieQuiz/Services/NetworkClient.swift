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
    // Простенькая реализация протокола Error для нашего случая
    private enum NetworkError: Error {
        case codeError
    }
    
    // MARK: - Methods
    // Функция запроса по заданному URL с API IMDb. Тип GET
    // Функция отдает результат асинхронно через handler
    // Метод инициируется MoviesLoader'ом
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void) {
        
        // Создаем запрос из URL
        let request = URLRequest(url: url)
        
        // Создаем задачу стоящую на паузе
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Проверяем, пришла ли ошибка
            if let error = error {
                handler(.failure(error))
                return
            }
            
            // Проверяем, что нам пришёл успешный код ответа
            if let response = response as? HTTPURLResponse,
                response.statusCode < 200 || response.statusCode >= 300 {
                handler(.failure(NetworkError.codeError))
                return
            }
            
            // Возвращаем данные
            guard let data = data else { return }
            handler(.success(data))
        }
        
        // Запускаем задачу
        task.resume()
    }
}
