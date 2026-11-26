//
//  EditProfileViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Наринэ  Овсепян on 26.11.2026.
//

import Foundation

@MainActor
class EditProfileViewModel: ObservableObject {
    @Published var name: String
    @Published var description: String
    @Published var website: String
    @Published var selectedImageData: Data?
    @Published var isSaving = false
    @Published var showError = false
    
    private let profileService: ProfileServiceProtocol
    private let currentProfile: UserProfile
    
    init(profile: UserProfile, service: ProfileServiceProtocol = ProfileService()) {
        self.currentProfile = profile
        self.profileService = service
        self.name = profile.name
        self.description = profile.description
        self.website = profile.website
    }
    
    var hasChanges: Bool {
        name != currentProfile.name ||
        description != currentProfile.description ||
        website != currentProfile.website ||
        selectedImageData != nil
    }
    
    func saveProfile() async -> Bool {
        guard hasChanges else { return true }
        isSaving = true
        defer { isSaving = false }
        
        do {
            if let imageData = selectedImageData {
                _ = try await profileService.uploadAvatar(imageData: imageData)
            }
            _ = try await profileService.updateProfile(
                name: name,
                description: description,
                website: website
            )
            return true
        } catch {
            showError = true
            return false
        }
    }
}
