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

                        VStack(alignment: .leading) {
                            Text("\(viewModel.collection.name.prefix(1).uppercased() + viewModel.collection.name.dropFirst())")
                                .font(.headline3)
                                .padding(.vertical, 8)
                                .padding(.bottom, 5)

                            HStack(spacing: 4) {
                                Text("Collection.author")
                                    .font(.caption2)

                                NavigationLink(
                                    destination: AuthorWebsiteView(
                                        url: viewModel.collection.website
                                    )
                                ) {
                                    Text(viewModel.collection.author)
                                        .font(.caption1)
                                        .foregroundStyle(.blueUniversal)
                                }
                            }
                            .padding(.bottom, 4)

                            Text(viewModel.collection.description.prefix(1).uppercased() + viewModel.collection.description.dropFirst())
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
