//
//  NetworkRoutingProtocol.swift
//  MovieQuiz
//
//  Created by Pavel Strezh on 14.08.2026.
//

import Foundation

protocol NetworkRoutingProtocol {
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void)
}
