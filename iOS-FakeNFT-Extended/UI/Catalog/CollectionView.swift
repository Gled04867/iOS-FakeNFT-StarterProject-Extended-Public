//
//  CollectionView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Олег Сергеевич on 19.11.2026.
//

import SwiftUI

struct CollectionView: View {
    @Environment(ServicesAssembly.self) private var service
    @State private var viewModel: CollectionViewModel?
    @State private var isErrorAlertPresented = false
    let collection: NftCollection

    var body: some View {
        Group {
            if let viewModel {
                ScrollView {
                    VStack {
                        AsyncImage(url: viewModel.collection.coverURL) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 310)
                        .clipShape(
                            UnevenRoundedRectangle(
                                bottomLeadingRadius: 12,
                                bottomTrailingRadius: 12
                            )
                        )
                        .padding(.bottom, 8)

                        VStack {
                            Text("\(viewModel.collection.name.prefix(1).uppercased() + viewModel.collection.name.dropFirst())")
                                .font(.headline3)
                                .padding(.vertical, 8)

                            HStack(spacing: 4) {
                                Text("Collection.author:")
                                    .font(.caption2)

                                Button {

                                } label: {
                                    Text(viewModel.user?.name ?? "Unknown.user")
                                        .font(.caption2)
                                        .foregroundStyle(.blueUniversal)
                                }
                            }

                            Text(viewModel.collection.description)
                                .font(.caption2)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 16)
                    }
                }
            } else {
                ProgressView()
            }
        }
        .task {
            if viewModel == nil {
                viewModel = CollectionViewModel(
                    collection: collection,
                    catalogService: service.catalogService,
                    nftService: service.nftService
                )
                viewModel?.startLoadingCollectionData()
            }
        }
        .alert(
            "Loading.error",
            isPresented: $isErrorAlertPresented
        ) {
            Button("Repeat.word") {
                viewModel?.retryLoading()
            }

            Button("Cancel.word", role: .cancel) {
                viewModel?.clearError()
            }
        } message: {
            Text(viewModel?.error?.localizedDescription ?? NSLocalizedString("Error.unknown", comment: ""))
        }
        .onChange(of: viewModel?.error != nil) { _, hasError in
            isErrorAlertPresented = hasError
        }
    }
}
