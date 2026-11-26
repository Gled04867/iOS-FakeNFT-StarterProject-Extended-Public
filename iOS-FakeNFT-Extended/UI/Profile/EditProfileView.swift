//
//  EditProfileView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Наринэ  Овсепян on 22.11.2026.
//

import SwiftUI

struct EditProfileView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String = "Иван Иванович"
    @State private var description: String = "Дизайнер из Казани..."
    @State private var website: String = "joao.ru"
    @State private var isPhotoDialogPresented = false
    
    
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                
                ZStack(alignment: .bottomTrailing) {
                    Image("avatar")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100) // Размер аватарки
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.gray.opacity(0.3), lineWidth: 1))
                    
                    Button {
                        print("Изменить фото")
                    } label: {
                        Image(systemName: "camera.fill")
                            .font(.system(size: 14, weight: .bold)) // Размер иконки
                            .foregroundColor(.black)
                            .frame(width: 32, height: 32)
                            .background(.grayLight)
                            .clipShape(Circle())
                    }
                    .offset(x: 6, y: 6)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    isPhotoDialogPresented = true
                }
                
                VStack(alignment: .leading) {
                    Text("Имя")
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    TextField("Введите имя", text: $name)
                        .padding(.horizontal, 16)
                        .frame(height: 44)
                        .background(.lightGrey)
                        .cornerRadius(12)
                    
                }
                
                VStack(alignment: .leading) {
                    Text("Описание").font(.headline)
                    
                    TextField("Описание", text: $description)
                        .padding(.horizontal, 16)
                        .frame(height: 44)
                        .background(.lightGrey)
                        .cornerRadius(12)
                }
                
                
                VStack(alignment: .leading, spacing: 12) {
                    
                    Text("Сайт").font(.headline)
                    TextField("Введите сайт", text: $website)
                        .padding(.horizontal, 16)
                        .frame(height: 44)
                        .background(.lightGrey)
                        .cornerRadius(12)
                        .keyboardType(.URL) // Включает удобную клавиатуру с точкой и слэшем
                        .autocapitalization(.none) // Отключает заглавные буквы
                    
                }
                Spacer()
                Button("Сохранить") {
                    print("Сохранено: \(name), \(description), \(website)")
                }
                .font(.system(size: 17, weight: .bold))
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blackDay)
                .foregroundColor(.white)
                .cornerRadius(16)
                .padding(.top, 20)
                
            }
            .padding()
            
            .sheet(isPresented: $isPhotoDialogPresented) {
                VStack(spacing: 20) {
                    Text("Фото профиля")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Button("Изменить фото") { isPhotoDialogPresented = false }
                    Button("Удалить фото", role: .destructive) { isPhotoDialogPresented = false }
                }
                .font(.title3)
                .frame(maxWidth: .infinity)
                .padding(.top, 20)
                .presentationDetents([.height(120)])
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss() // Закрываем экран
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.primary)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
#Preview {
    EditProfileView()
}

