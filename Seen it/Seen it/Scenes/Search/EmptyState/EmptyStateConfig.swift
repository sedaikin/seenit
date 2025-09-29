//
//  EmptyStateConfig.swift
//  Seen it
//
//  Created by Rogova Mariya on 28.09.2025.
//

import UIKit

enum EmptyStateType {
    case initialSearch
    case loading(query: String)
    case noResults(query: String)
    case error(Error)

    var image: UIImage? {
        switch self {
        case .initialSearch:
            return UIImage(systemName: "magnifyingglass")?
                .withTintColor(.systemGray, renderingMode: .alwaysOriginal)
        case .loading:
            return UIImage(systemName: "hourglass")?
                .withTintColor(.systemGray, renderingMode: .alwaysOriginal)
        case .noResults:
            return UIImage(systemName: "questionmark.square")?
                .withTintColor(.systemGray, renderingMode: .alwaysOriginal)
        case .error:
            return UIImage(systemName: "exclamationmark.triangle")?
                .withTintColor(.systemOrange, renderingMode: .alwaysOriginal)
        }
    }

    var title: String {
        switch self {
        case .initialSearch:
            return "Начните вводить запрос для поиска фильмов"
        case .loading(let query):
            return "Ищем \"\(query)\"..."
        case .noResults(let query):
            return "По запросу \"\(query)\" ничего не найдено\nПопробуйте другой запрос"
        case .error(let error):
            return errorMessage(for: error)
        }
    }

    private func errorMessage(for error: Error) -> String {
        guard let networkError = error as? NetworkError else {
            return "Произошла ошибка при поиске\nПопробуйте еще раз"
        }

        switch networkError {
        case .serverError(let statusCode):
            return "Ошибка сервера (\(statusCode))\nПопробуйте еще раз"
        case .noData:
            return "Нет данных от сервера\nПопробуйте еще раз"
        case .invalidURL:
            return "Неверный URL запроса\nПопробуйте еще раз"
        case .decodingError:
            return "Ошибка обработки данных\nПопробуйте еще раз"
        }
    }
}
