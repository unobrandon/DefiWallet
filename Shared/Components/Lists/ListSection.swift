//
//  ListSection.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/26/22.
//

import SwiftUI

struct ListSection<Content: View>: View {

    private let content: Content
    private let title: String
    private let style: AppStyle

    init(title: String, style: AppStyle, @ViewBuilder _ content: () -> Content) {
        self.title = title
        self.style = style
        self.content = content()
    }

    init(style: AppStyle, @ViewBuilder _ content: () -> Content) {
        self.title = ""
        self.style = style
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title.isEmpty ? "" : title + ":")
                .font(.caption)
                .fontWeight(.regular)
                .textCase(.uppercase)
                .foregroundColor(.secondary)
                .padding(.horizontal)

            VStack(alignment: .center, spacing: 0) { content }
                .background(style == .shadow ? Color("baseButton") : Color.clear)
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .circular))
                .shadow(color: Color.black.opacity(style == .shadow ? 0.15 : 0.0), radius: 15, x: 0, y: 8)
                .overlay(RoundedRectangle(cornerRadius: 15, style: .circular).stroke(DefaultTemplate.borderColor.opacity(style == .border ? 1.0 : 0.0), lineWidth: 2))
                .padding(.bottom, 5)
                .padding(.horizontal, 2)
        }
        .padding(.bottom)
        .padding(.horizontal)
    }
}
