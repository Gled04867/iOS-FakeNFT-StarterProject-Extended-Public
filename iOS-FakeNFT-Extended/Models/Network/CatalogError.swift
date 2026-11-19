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
            return "\(NSLocalizedString("Error.server", comment: "")) (\(statusCode))"
        case .clientError(let statusCode):
            return "\(NSLocalizedString("Error.client", comment: "")) (\(statusCode))"
        case .networkError:
            return NSLocalizedString("Error.network", comment: "")
        case .parsingError:
            return NSLocalizedString("Error.parsing", comment: "")
        case .requestError:
            return NSLocalizedString("Error.request", comment: "")
        case .unknownError:
            return NSLocalizedString("Error.unknown", comment: "")
        case .timeoutError:
            return NSLocalizedString("Error.timeout", comment: "")
        }
    }
}
