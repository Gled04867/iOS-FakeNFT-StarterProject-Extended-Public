//
//  ProfileViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Наринэ  Овсепян on 25.11.2026.
//
import Foundation

@MainActor

class ProfileViewModel: ObservableObject {
    @Published var profile: UserProfile?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    @Published var isEditing = false
    
    private let services: ServicesAssembly
    
    init(services: ServicesAssembly) {
            self.services = services
        }
    
    var nftCount: Int {
        profile?.nfts.count ?? 0
    }
    
    var websiteURL: URL? {
            guard let websiteString = profile?.website else { return nil }
            return URL(string: websiteString)
        }
    func loadProfile() async {
            isLoading = true
        errorMessage = nil
                
                do {
                    self.profile = try await services.profileService.fetchProfile()
                } catch {
                    self.errorMessage = "Не удалось загрузить профиль: \(error.localizedDescription)"
                    print("Ошибка загрузки: \(error)")
                }
                
                isLoading = false
        
        /*
         do {
         let service = ProfileService()
                     self.profile = try await service.fetchProfile()
                 } catch {
                     print("Ошибка загрузки: \(error)")
                 }
             }
         */
            }
    
    func openEditScreen() {
            isEditing = true
        }
}
