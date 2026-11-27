//
//  Untitled.swift
//  iOS-FakeNFT-Extended
//
//  Created by Наринэ  Овсепян on 26.11.2026.
//
import Foundation

protocol ProfileServiceProtocol {
    func fetchProfile() async throws -> UserProfile
    
    func updateProfile(name: String, description: String, website: String, avatarUrl: String?) async throws -> UserProfile
}


class ProfileService: ProfileServiceProtocol {
    
    private let networkClient: NetworkClient
    
    private let profileId = "431a48d1-40cf-4242-9b09-492dc61af689"
    
    init(networkClient: NetworkClient) {
            self.networkClient = networkClient
        }
    
    func fetchProfile() async throws -> UserProfile {
        
        let request = GetProfileRequest(id: profileId)
        return try await networkClient.send(request: request)
       /* return UserProfile(
                    id: "1",
                    name: "Студентус Практикумс",
                    avatar: "https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/574.jpg",
                    description: "Дизайнер из Казани, люблю цифровое искусство и бейглы...",
                    website: "https://practicum.yandex.ru/async-python/",
                    nfts: [],
                    likes: []
                )*/
    }
    
    func updateProfile(name: String, description: String, website: String, avatarUrl: String?) async throws -> UserProfile {
        let dto = UpdateProfileDto(name: name, description: description, website: website, avatar: avatarUrl)
                let request = UpdateProfileRequest(id: profileId, dto: dto)
                return try await networkClient.send(request: request)
    }
}
