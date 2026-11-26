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
    
    var nftCount: Int {
        profile?.nfts.count ?? 0
    }
    
    var websiteURL: URL? {
            guard let websiteString = profile?.website else { return nil }
            return URL(string: websiteString)
        }
    func loadProfile() async {
            isLoading = true
        
        self.profile = UserProfile(
                    id: "431a48d1-40cf-4242-9b09-492dc61af689",
                    name: "Студентус Практикумс",
                    avatar: "https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/574.jpg",
                    description: "Дизайнер из Казани, люблю цифровое искусство и бейглы...",
                    website: "https://practicum.yandex.ru/async-python/",
                    nfts: [],
                    likes: ["b3907b86-37c4-4e15-95bc-7f8147a9a660"]
                )
                isLoading = false
            }
}
