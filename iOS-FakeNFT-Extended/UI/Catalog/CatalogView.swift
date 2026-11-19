//
//  CatalogView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Олег Сергеевич on 19.11.2026.
//

import SwiftUI

struct CatalogView: View {
    @State private var viewModel: CatalogViewModel
    @State private var isSortDialogPresented = false

    init(viewModel: CatalogViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.collections, id: \.id) { collection in
                    CollectionCell(collection: collection)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets(
                            top: 0,
                            leading: 16,
                            bottom: 8,
                            trailing: 16
                        ))
                        .task {
                            if collection.id == viewModel.collections.last?.id {
                                await viewModel.loadCollections()
                            }
                        }
                }
            }
            .scrollContentBackground(.hidden)
            .contentMargins(.horizontal, 0, for: .scrollContent)
            .contentMargins(.top, 20, for: .scrollContent)
            .task {
                await viewModel.loadCollections()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isSortDialogPresented = true
                    } label: {
                        Image(.sort)
                            .frame(width: 42, height: 42)
                            .foregroundStyle(.ypBlack)
                    }
                }
            }
            .confirmationDialog(
                "Sorting.title",
                isPresented: $isSortDialogPresented,
                titleVisibility: .visible
            ) {
                Button("Sorting.byName") {
                    //TODO: add sort by name
                }
                Button("Sorting.byNFTCount") {
                    //TODO: add sort by count NFT
                }
                Button("Close.title", role: .cancel) {}
            }
            .overlay {
                if viewModel.isLoading && viewModel.collections.isEmpty {
                    ProgressView()
                }
            }
        }
    }
}
