//
//  CatalogServiceError.swift
//  iOS-FakeNFT-Extended
//
//  Created by Олег Сергеевич on 24.11.2026.
//

import Foundation

enum CatalogServiceError: Error {
    case nftIDMismatch(expected: String, received: String)
    case missingNft(id: String)
}
