//
//  CollectionViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Олег Сергеевич on 26.11.2026.
//

import Foundation
import Observation

@Observable
@MainActor
final class CollectionViewModel {
    var nfts: [Nft] = []
    var isLoading = false
    var error: CatalogError?
    let collection: NftCollection
    let nftService: NftService

    private var loadingTask: Task<Void, Never>?

    init(
        collection: NftCollection,
        nftService: NftService
    ) {
        self.collection = collection
        self.nftService = nftService
    }

    // MARK: - Public Methods
    func startLoadingCollectionData() {
        guard loadingTask == nil else { return }

        loadingTask = Task {
            await loadCollectionData()
            loadingTask = nil
        }
    }

    func loadCollectionData() async {
        guard !isLoading else { return }

        error = nil
        isLoading = true

        defer { isLoading = false }

        do {
            let nfts = try await nftService.loadNfts(ids: collection.nfts)
            try Task.checkCancellation()
            self.nfts = nfts
        } catch is CancellationError {
            return
        } catch {
            guard !Task.isCancelled else { return }
            self.error = mapError(error)
        }
    }

    func retryLoading() {
        guard error != nil else { return }

        error = nil
        startLoadingCollectionData()
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
