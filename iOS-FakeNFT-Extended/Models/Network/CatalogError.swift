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
            return "Error.server (\(statusCode))"
        case .clientError(let statusCode):
            return "Error.client (\(statusCode))"
        case .networkError:
            return "Error.network"
        case .parsingError:
            return "Error.parsing"
        case .requestError:
            return "Error.request"
        case .unknownError:
            return "Error.unknow"
        case .timeoutError:
            return "Error.timeout"
        }
    }
}
