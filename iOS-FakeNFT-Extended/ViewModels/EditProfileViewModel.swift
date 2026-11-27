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
    private let onSaveSuccess: (UserProfile) -> Void
    private let currentProfile: UserProfile
    
    init(profile: UserProfile, service: ProfileServiceProtocol, onSaveSuccess: @escaping (UserProfile) -> Void) {
        self.currentProfile = profile
        self.profileService = service
        self.name = profile.name
        self.description = profile.description
        self.website = profile.website
        self.onSaveSuccess = onSaveSuccess
    }
    
    var hasChanges: Bool {
        name != currentProfile.name ||
        description != currentProfile.description ||
        website != currentProfile.website ||
        selectedImageData != nil
    }
    
    func saveProfile() async {
        isSaving = true
                showError = false
                
                do {
                    let updatedProfile = try await profileService.updateProfile(
                                    name: name,
                                    description: description,
                                    website: website
                                )
                    onSaveSuccess(updatedProfile)
                                isSaving = false
                                
                } catch {
                    print("❌ Ошибка сохранения: \(error)")
                    isSaving = false
                    showError = true
                }
    }
}
