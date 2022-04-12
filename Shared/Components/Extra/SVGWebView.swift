//
//  SVGWebView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 4/12/22.
//

import SwiftUI
import WebKit

struct SVGWebView: UIViewRepresentable {

    let loadURL: String
    @Binding var isAvailable: Bool

    init(_ loadURL: String, isAvailable: Binding<Bool>) {
        self.loadURL = loadURL
        self._isAvailable = isAvailable
    }

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.scrollView.isScrollEnabled = false
        webView.isUserInteractionEnabled = false
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let url = URL(string: loadURL) {
            do {
                let contents = try String(contentsOf: url)
                let html = contents + "<style>html, body { width: 100%; height: 100%; margin: 0; padding: 0 }</style><meta name=\"viewport\" content=\"width=device-width, shrink-to-fit=YES\">"
                uiView.loadHTMLString(html, baseURL: nil)
                isAvailable = true
            } catch {
                isAvailable = false
            }
        } else {
            isAvailable = false
        }
    }

}
