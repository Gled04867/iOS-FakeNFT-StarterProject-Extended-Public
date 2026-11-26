//
//  WebView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Олег Сергеевич on 26.11.2026.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    @Binding var isLoading: Bool
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        let request = URLRequest(url: url)
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webView.load(request)
        return webView
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {

    }

    func makeCoordinator() -> Coordinator {
        let binding = $isLoading

        return Coordinator { isLoading in
            binding.wrappedValue = isLoading
        }
    }
}

class Coordinator: NSObject, WKNavigationDelegate {
    var onLoadingChanged: ((Bool) -> Void)?

    init(onLoadingChanged: ((Bool) -> Void)? = nil) {
        self.onLoadingChanged = onLoadingChanged
        super.init()
    }

    func webView(
        _ webView: WKWebView,
        didStartProvisionalNavigation navigation: WKNavigation?
    ) {
        onLoadingChanged?(true)
    }

    func webView(
        _ webView: WKWebView,
        didFinish navigation: WKNavigation?
    ) {
        onLoadingChanged?(false)
    }
}
