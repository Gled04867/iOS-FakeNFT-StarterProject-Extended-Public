//
//  CatalogError.swift
//  iOS-FakeNFT-Extended
//
//  Created by Олег Сергеевич on 19.11.2026.
//

import Foundation

enum CatalogError: LocalizedError {
    case serverError(Int)
    case clientError(Int)
    case networkError
    case parsingError
    case requestError
    case unknownError
    case timeoutError

    var errorDescription: String? {
        switch self {
        case .serverError(let statusCode):
            "\(NSLocalizedString("Error.server", comment: "")) (\(statusCode))"
        case .clientError(let statusCode):
            "\(NSLocalizedString("Error.client", comment: "")) (\(statusCode))"
        case .networkError:
            NSLocalizedString("Error.network", comment: "")
        case .parsingError:
            NSLocalizedString("Error.parsing", comment: "")
        case .requestError:
            NSLocalizedString("Error.request", comment: "")
        case .unknownError:
            NSLocalizedString("Error.unknown", comment: "")
        case .timeoutError:
            NSLocalizedString("Error.timeout", comment: "")
        }
    }
}
