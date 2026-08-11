//
//  MostPopularMovies.swift
//  MovieQuiz
//
//  Created by Pavel Strezh on 10.08.2026.
//

import Foundation

// Структура JSON
struct MostPopularMovies: Codable {
    let errorMessage: String
    let items: [MostPopularMovie]
}

// Структура конкретного фильма
struct MostPopularMovie: Codable {
    let title: String
    let rating: String
    let imageURL: URL
    
//    // указываем как называются поля в API json-ответе
//    private enum CodingKeys: String, CodingKey {
//        case title = "fullTitle"
//        case rating = "imDbRating"
//        case imageURL = "image"
//    }
    
//    // Инициализация констант
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        title = try container.decode(String.self, forKey: title)
//        rating = try container.decode(String.self, forKey: rating)
//        imageURL = try container.decode(String.self, forKey: imageURL)
//        
//    }
}

