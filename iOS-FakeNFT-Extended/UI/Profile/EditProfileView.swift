//
//  EditProfileView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Наринэ  Овсепян on 22.11.2026.
//

import SwiftUI

struct EditProfileView: View {
    
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: EditProfileViewModel
    
    @State private var isPhotoDialogPresented = false
    @State private var isUrlAlertPresented = false
    @State private var inputUrl: String = ""
    
    init(profile: UserProfile, services: ServicesAssembly, onSaveSuccess: @escaping (UserProfile) -> Void) {
        _viewModel = StateObject(wrappedValue: EditProfileViewModel(
            profile: profile,
            service: services.profileService,
            onSaveSuccess: onSaveSuccess
        ))
    }
    
    
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    
                    ZStack(alignment: .bottomTrailing) {
                        if let urlString = viewModel.avatarUrl, let url = URL(string: urlString) {
                            AsyncImage(url: url) { image in
                                image.resizable().scaledToFill()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                        } else {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .foregroundColor(.gray)
                        }
                        
                        Image(systemName: "camera.fill")
                            .font(.system(size: 14, weight: .bold)) // Размер иконки
                            .foregroundColor(.black)
                            .frame(width: 32, height: 32)
                            .background(.grayLight)
                            .clipShape(Circle())
                            .offset(x: 6, y: 6)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    isPhotoDialogPresented = true
                }
                
                VStack(alignment: .leading) {
                    Text("Имя")
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    TextField("Введите имя", text: $viewModel.name)
                        .padding(.horizontal, 16)
                        .frame(height: 44)
                        .background(.lightGrey)
                        .cornerRadius(12)
                    
                }
                
                VStack(alignment: .leading) {
                    Text("Описание")
                        .font(.headline)
                    
                    ZStack(alignment: .topLeading) {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.lightGrey)
                        
                        TextEditor(text: $viewModel.description)
                            .scrollContentBackground(.hidden)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .textContentType(.none)
                            .autocorrectionDisabled()
                    }
                    .frame(height: 100)
                }
                
                
                VStack(alignment: .leading, spacing: 12) {
                    
                    Text("Сайт").font(.headline)
                    TextField("Введите сайт", text: $viewModel.website)
                        .padding(.horizontal, 16)
                        .frame(height: 44)
                        .background(.lightGrey)
                        .cornerRadius(12)
                        .keyboardType(.URL)
                    /*.autocapitalization(.none)*/
                        .textInputAutocapitalization(.never) // Отключает заглавные буквы
                    
                }
            }
            .padding()
        }
        .scrollDismissesKeyboard(.interactively)
        
        .safeAreaInset(edge: .bottom) {
            Button {
                Task { await viewModel.saveProfile()
                    if !viewModel.showError {
                        dismiss()
                    }
                }
            } label: {
                if viewModel.isSaving {
                    ProgressView().tint(.white)
                } else {
                    Text("Сохранить")
                }
            }
            .font(.system(size: 17, weight: .bold))
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blackDay)
            .foregroundColor(.white)
            .cornerRadius(16)
            .padding(.horizontal)
            .padding(.bottom, 8)
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.primary)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        
        /*  .sheet(isPresented: $isPhotoDialogPresented) {
            VStack(spacing: 20) {
             Text("Фото профиля")
             .font(.headline)
             .foregroundColor(.secondary)
             
             Button("Изменить фото") {
             inputUrl = viewModel.avatarUrl ?? ""
             isPhotoDialogPresented = false
             DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
             isUrlAlertPresented = true
             }
             }
             .font(.title3)
             
             Button("Удалить фото", role: .destructive) {
             viewModel.avatarUrl = nil
             isPhotoDialogPresented = false
             }
             .font(.title3)
             .frame(maxWidth: .infinity)
             .padding()
             .background(Color(.systemGray5))
             .cornerRadius(12)
             /*.presentationDetents([.height(120)])*/
             
             Spacer()
             }
             .padding(.horizontal)
             .padding(.top, 20)
             .presentationDetents([.height(220)])
             }*/
            .confirmationDialog("Фото профиля", isPresented: $isPhotoDialogPresented, titleVisibility: .visible) {
                Button("Изменить фото") {
                    inputUrl = viewModel.avatarUrl ?? ""
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        isUrlAlertPresented = true
                    }
                }
                
                Button("Удалить фото", role: .destructive) {
                    viewModel.avatarUrl = nil
                }
                
                Button("Отмена", role: .cancel) { }
            }
            
            .alert("Ссылка на фото", isPresented: $isUrlAlertPresented) {
                TextField("http://example.com", text: $inputUrl)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.URL)
                
                Button("Отмена", role: .cancel) { }
                
                Button("Сохранить") {
                    viewModel.avatarUrl = inputUrl
                }
            }
        }
    }
/*#Preview {
     EditProfileView()
     }*/
    
