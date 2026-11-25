//
//  ProfileView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Наринэ  Овсепян on 18.11.2026.
//
import SwiftUI

struct ProfileController: View {
    var body: some View {
        VStack(spacing: 24) {
            
            HStack {
                Spacer()
                Button {
                    print("Обновить")
                } label: {
                    Image("update")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 42, height: 42) // задаем размер самой иконки
                }
                .frame(width: 42, height: 42) // область нажатия (тап-зона)
            }
            
            HStack(spacing: 16) {
                Image("avatar")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 72, height: 72)
                    .clipShape(Circle())
                    .overlay(
                        Circle().stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                
                Text("Иван Иванович")
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Spacer()
            }
            
            
            VStack(alignment: .leading, spacing: 12) {
                
                Text("Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT, и еще больше — на моём сайте. Открыт к коллаборациям.")
                    .font(.system(size: 13))
                    .foregroundColor(.blackDay)
                
                Text("@ivanov")
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
    }
}
#Preview {
    ProfileController()
}
