//
//  User.swift
//  iOS-FakeNFT-Extended
//
//  Created by Олег Сергеевич on 23.11.2026.
//

import Foundation

struct User: Decodable, Sendable {
    let name: String
    let avatarURL: URL
    let description: String
    let websiteURL: URL
    let nfts: [String]
    let rating: String
    let id: String

    enum CodingKeys: String, CodingKey {
        case name
        case avatarURL = "avatar"
        case description
        case websiteURL = "website"
        case nfts
        case rating
        case id
    }
}
