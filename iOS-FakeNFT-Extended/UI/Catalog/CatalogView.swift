//
//  CatalogView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Олег Сергеевич on 19.11.2026.
//

import SwiftUI

struct CatalogView: View {
    @AppStorage("catalogSortOption") private var savedSortOption = CatalogSortOption.byNftCount.rawValue
    @State private var viewModel: CatalogViewModel
    @State private var isSortDialogPresented = false
    @State private var isErrorAlertPresented = false

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
                                viewModel.startLoadingCollections()
                            }
                        }
                }
                if viewModel.isLoading && !viewModel.collections.isEmpty {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                }
            }
            .scrollContentBackground(.hidden)
            .contentMargins(.horizontal, 0, for: .scrollContent)
            .contentMargins(.top, 20, for: .scrollContent)
            .task {
                let option = CatalogSortOption(rawValue: savedSortOption) ?? .byNftCount
                await viewModel.updateSortOption(option)
                viewModel.startLoadingCollections()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isSortDialogPresented = true
                    } label: {
                        Image(.sort)
                            .frame(width: 42, height: 42)
                            .foregroundStyle(.black)
                    }
                }
            }
            .confirmationDialog(
                "Sorting.title",
                isPresented: $isSortDialogPresented,
                titleVisibility: .visible
            ) {
                Button("Sorting.byName") {
                    changeSortOption(.byName)
                }
                Button("Sorting.byNftCount") {
                    changeSortOption(.byNftCount)
                }
                Button("Close.title", role: .cancel) {}
            }
            .alert(
                "Loading.error",
                isPresented: $isErrorAlertPresented
            ) {
                Button("Repeat.word") {
                    viewModel.retryLoading()
                }

                Button("Cancel.word", role: .cancel) {
                    viewModel.clearError()
                }
            } message: {
                Text(viewModel.error?.localizedDescription ?? "Error.unknow")
            }
            .onChange(of: viewModel.error != nil) { _, hasError in
                isErrorAlertPresented = hasError
            }
            .overlay {
                if viewModel.isLoading && viewModel.collections.isEmpty {
                    ProgressView()
                } else if !viewModel.isLoading
                            && viewModel.collections.isEmpty
                            && viewModel.error == nil {
                    ContentUnavailableView(
                        "Catalog.empty",
                        systemImage: "square.stack.3d.up",
                        description: Text("Collection.emptyYet")
                    )
                }
            }
        }
    }

    private func changeSortOption(_ option: CatalogSortOption) {
        savedSortOption = option.rawValue

        Task {
            await viewModel.updateSortOption(option)
            viewModel.startLoadingCollections()
        }
    }
}
