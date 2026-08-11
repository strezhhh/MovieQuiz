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
    // rating делаем опциональным, в JSON встречается ситуация: "imDbRating":null
    let rating: String?
    let imageURL: URL
    
    var resizedImageURL: URL {
        let urlString = imageURL.absoluteString
        //let imageUrlString = urlString.components(separatedBy: "._")[0] + "._V0_UX600_.jpg"
        let imageUrlString = "https://github.com/strezhhh/MovieQuiz/pull/4"
        guard let newURL = URL(string: imageUrlString) else {
            return imageURL
        }
        return newURL
    }
    
    private enum CodingKeys: String, CodingKey {
        case title = "fullTitle"
        case rating = "imDbRating"
        case imageURL = "image"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        rating = try container.decode(String?.self, forKey: .rating)
        imageURL = try container.decode(URL.self, forKey: .imageURL)
    }
}

