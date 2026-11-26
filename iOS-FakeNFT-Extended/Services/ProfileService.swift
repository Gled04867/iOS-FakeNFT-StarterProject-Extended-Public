//
//  Untitled.swift
//  iOS-FakeNFT-Extended
//
//  Created by Наринэ  Овсепян on 26.11.2026.
//
import Foundation

protocol ProfileServiceProtocol {
    func fetchProfile() async throws -> UserProfile
    
    func updateProfile(name: String, description: String, website: String) async throws -> UserProfile
    
    func uploadAvatar(imageData: Data) async throws -> String
    func logout() async throws
}


class ProfileService: ProfileServiceProtocol {
    func fetchProfile() async throws -> UserProfile {
        return UserProfile(
                    id: "1",
                    name: "Студентус Практикумс",
                    avatar: "https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/574.jpg",
                    description: "Дизайнер из Казани, люблю цифровое искусство и бейглы...",
                    website: "https://practicum.yandex.ru/async-python/",
                    nfts: [],
                    likes: []
                )
    }
    
    func updateProfile(name: String, description: String, website: String) async throws -> UserProfile {
        // Здесь будет URLSession запрос (PUT/PATCH)
        // Пока возвращаем фейк, чтобы UI работал:
        
        return UserProfile(id: "1", name: "name", avatar: "description", description: "website", website: "ccskrf", nfts: ["112"], likes: ["11"])
    }
    
    func uploadAvatar(imageData: Data) async throws -> String {
        return "https://example.com/new-avatar.jpg"
    }
    
    func logout() {
    }
}
