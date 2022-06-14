//
//  YTVideoView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 6/13/22.
//

import SwiftUI
import WebKit

struct YTVideoView: UIViewRepresentable {

    let videoId: String

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let youtubeURL = URL(string: "https://www.youtube.com/embed/\(videoId)") else { return }
        uiView.scrollView.isScrollEnabled = false
        uiView.load(URLRequest(url: youtubeURL))
    }

}
