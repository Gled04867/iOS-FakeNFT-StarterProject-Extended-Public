//
//  NftCollectionsRequest.swift
//  iOS-FakeNFT-Extended
//
//  Created by Олег Сергеевич on 18.11.2026.
//

import Foundation

struct NftCollectionsRequest: NetworkRequest {
    let page: Int
    let size: Int
    let sortBy: String?

    var endpoint: URL? {
        let sortParameter = sortBy.map { "&sortBy=\($0)" } ?? ""
        return URL(string: "\(RequestConstants.baseURL)/api/v1/collections?page=\(page)&size=\(size)\(sortParameter)")
    }
}
