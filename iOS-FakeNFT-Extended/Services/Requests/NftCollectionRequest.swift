//
//  NftCollectionRequest.swift
//  iOS-FakeNFT-Extended
//
//  Created by Олег Сергеевич on 24.11.2026.
//

import Foundation

struct NftCollectionRequest: NetworkRequest {

    let id: String

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/collections/\(id)")
    }
}
