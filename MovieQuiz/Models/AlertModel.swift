//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Pavel Strezh on 23.07.2026.
//

import UIKit

// Структура данных для Алерты с результатами Квиза.
struct AlertModel {
    let title: String,
    let message: String,
    let buttonText: String,
    let completion: () -> Void
}
