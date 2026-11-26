//
//  ProfileView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Наринэ  Овсепян on 18.11.2026.
//
import SwiftUI

struct ProfileView: View {
    
    @State private var isEditPresented = false
    @StateObject private var viewModel: ProfileViewModel
        
    init(services: ServicesAssembly) {
            _viewModel = StateObject(wrappedValue: ProfileViewModel(services: services))
        }
    
    var body: some View {
        VStack(spacing: 24) {
            
            HStack {
                Spacer()
                Button {
                    viewModel.openEditScreen()
                } label: {
                    Image("update")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 42, height: 42) // задаем размер самой иконки
                }
                .frame(width: 42, height: 42) // область нажатия (тап-зона)
            }
            
            HStack(spacing: 16) {
                /*Image("avatar")
                 .resizable()*/
                if let avatarUrlString = viewModel.profile?.avatar,
                   let url = URL(string: avatarUrlString) {
                    
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        ProgressView()
                    }
                    
                    
                    
                    
                    .scaledToFill()
                    .frame(width: 72, height: 72)
                    .clipShape(Circle())
                    .overlay(
                        Circle().stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                    
                } else {
                    Image("avatar")
                                .resizable()
                                .frame(width: 72, height: 72)
                                .foregroundColor(.gray.opacity(0.5))
                        }
                
                Text(viewModel.profile?.name ?? "Загрузка...")
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Spacer()
            }
            
            
            VStack(alignment: .leading, spacing: 12) {
                
                Text(viewModel.profile?.description ?? "")
                    .font(.system(size: 13))
                    .foregroundColor(.blackDay)
                
                Text(viewModel.profile?.website ?? "")
                    .font(.subheadline)
                    .foregroundColor(.blueUniversal)
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 0) {
                ProfileMenuRow(title: "Мои NFT", count: 112) {
                    print("Переход на Мои NFT")
                }
                
                ProfileMenuRow(title: "Избранные NFT", count: 11) {
                    print("Переход в Избранное")
                }
            }
            Spacer()
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .task {
                    await viewModel.loadProfile()
                }
        .fullScreenCover(isPresented: $viewModel.isEditing) {
            EditProfileView() // Передаем экран редактирования
        }
    }
}
/*#Preview {
    ProfileView()
}*/
