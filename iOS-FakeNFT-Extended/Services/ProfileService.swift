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
        <#code#>
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
