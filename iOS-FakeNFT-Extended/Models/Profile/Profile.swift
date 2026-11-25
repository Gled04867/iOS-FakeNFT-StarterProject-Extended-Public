//
//  Profile.swift
//  iOS-FakeNFT-Extended
//
//  Created by Наринэ  Овсепян on 25.11.2026.
//
import  Foundation

struct UserProfile: Codable, Identifiable {
    let id: String
    let name: String
    let avatar: String?
    let description: String
    let website: String
    let nfts: [String]
    let likes: [String]
}



enum AvatarAction {
    case change
    case delete
}
