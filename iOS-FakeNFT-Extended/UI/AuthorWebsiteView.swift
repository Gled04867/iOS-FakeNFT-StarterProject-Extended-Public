//
//  AuthorWebsiteView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Олег Сергеевич on 26.11.2026.
//

import SwiftUI

struct AuthorWebsiteView: View {
    @State private var isLoading = true
    let url: URL

    var body: some View {
        ZStack {
            WebView(isLoading: $isLoading, url: url)
            if isLoading {
                ProgressView()
            }
        }
    }
}
