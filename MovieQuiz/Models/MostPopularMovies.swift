//
//  MostPopularMovies.swift
//  MovieQuiz
//
//  Created by Pavel Strezh on 10.08.2026.
//

import Foundation

// Структура JSON
struct MostPopularMovies: Codable {
    let errorMessage: String?
    let items: [MostPopularMovie]
}

// Структура конкретного фильма
struct MostPopularMovie: Codable {
    let title: String
    // rating делаем опциональным, в JSON встречается ситуация: "imDbRating":null
    let rating: String?
    let imageURL: URL
    
    var resizedImageURL: URL {
            // создаем строку из адреса
            let urlString = imageURL.absoluteString
            //  обрезаем лишнюю часть и добавляем модификатор желаемого качества
            let imageUrlString = urlString.components(separatedBy: "._")[0] + "._V0_UX600_.jpg"
            
            // пытаемся создать новый адрес, если не получается возвращаем старый
            guard let newURL = URL(string: imageUrlString) else {
                return imageURL
            }
            
            return newURL
        }
    
    // указываем как называются поля в API json-ответе
    private enum CodingKeys: String, CodingKey {
        case title = "fullTitle"
        case rating = "imDbRating"
        case imageURL = "image"
    }
    
    // Инициализация констант
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        rating = try container.decode(String?.self, forKey: .rating)
        imageURL = try container.decode(URL.self, forKey: .imageURL)
    }
}

