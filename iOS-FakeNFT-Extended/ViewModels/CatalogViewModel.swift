//
//  CatalogViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Олег Сергеевич on 18.11.2026.
//

import Foundation
import Observation

@Observable
@MainActor
final class CatalogViewModel {
    var collections: [NftCollection] = []
    var isLoading = false
    var error: CatalogError?
    var sortOption: CatalogSortOption = .byNftCount

    private var currentPage = 0
    private var hasMorePages = true
    private var loadingTask: Task<Void, Never>?
    private let pageSize = 5
    private let catalogService: CatalogService

    init(catalogService: CatalogService) {
        self.catalogService = catalogService
    }

    // MARK: - Public Methods
    func startLoadingCollections() {
        guard loadingTask == nil else { return }

        loadingTask = Task {
            await loadCollections()
            loadingTask = nil
        }
    }

    func loadCollections() async {
        guard !isLoading, hasMorePages else { return }

        error = nil
        isLoading = true

        defer { isLoading = false }

        do {
            repeat {
                let page = try await catalogService.loadCollections(
                    page: currentPage,
                    size: pageSize,
                    sortBy: sortOption.sortBy
                )
                try Task.checkCancellation()
                collections.append(contentsOf: page)
                hasMorePages = page.count == pageSize
                currentPage += 1
            } while hasMorePages && sortOption == .byNftCount

            if sortOption == .byNftCount {
                collections.sort {
                    $0.nfts.count > $1.nfts.count
                }
            }
        } catch is CancellationError {
            return
        } catch {
            guard !Task.isCancelled else { return }
            self.error = mapError(error)
        }
    }

    func updateSortOption(_ option: CatalogSortOption) async {
        guard option != sortOption else { return }

        loadingTask?.cancel()
        await loadingTask?.value
        loadingTask = nil

        sortOption = option
        collections.removeAll()
        currentPage = 0
        hasMorePages = true
        error = nil
    }

    func retryLoading() {
        guard error != nil else { return }

        error = nil
        startLoadingCollections()
    }

    func clearError() {
        error = nil
    }

    // MARK: - Private Methods
    private func mapError(_ error: Error) -> CatalogError {
        if let networkError = error as? NetworkClientError {
            switch networkError {
            case .httpStatusCode(let statusCode):
                switch statusCode {
                case 400..<500:
                    return .clientError(statusCode)
                case 500..<600:
                    return .serverError(statusCode)
                default:
                    return .unknownError
                }
            case .urlRequestError(let underlyingError):
                return mapURLError(underlyingError)
            case .urlSessionError:
                return .unknownError
            case .parsingError:
                return .parsingError
            case .incorrectRequest:
                return .requestError
            }
        }

        if let urlError = error as? URLError {
            return mapURLError(urlError)
        }

        return .unknownError
    }

    private func mapURLError(_ error: Error) -> CatalogError {
        guard let urlError = error as? URLError else {
            return .unknownError
        }

        switch urlError.code {
        case .notConnectedToInternet,
                .cannotFindHost,
                .cannotConnectToHost,
                .dnsLookupFailed,
                .networkConnectionLost:
            return .networkError
        case .timedOut:
            return .timeoutError
        default:
            return .networkError
        }
    }
}
