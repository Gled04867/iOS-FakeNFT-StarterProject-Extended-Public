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

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/collections?page=\(page)&size=\(size)")
    }
}
