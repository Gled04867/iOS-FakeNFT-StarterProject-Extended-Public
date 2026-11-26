//
//  NftCollection.swift
//  iOS-FakeNFT-Extended
//
//  Created by Олег Сергеевич on 18.11.2026.
//

import Foundation

struct NftCollection: Decodable, Sendable {
    let id: String
    let name: String
    let coverURL: URL
    let nfts: [String]
    let description: String
    let author: String
    let website: URL

    enum CodingKeys: String, CodingKey {
        case id, name, nfts, description, author, website
        case coverURL = "cover"
    }
}
