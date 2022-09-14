//
//  ListSection.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/26/22.
//

import SwiftUI

struct ListSection<Content: View>: View {

    private let content: Content
    private let title: String?
    private let style: AppStyle
    private let hasPadding: Bool?
    private let removeShadow: Bool?

    init(title: String? = nil, hasPadding: Bool? = true, removeShadow: Bool? = false, style: AppStyle, @ViewBuilder _ content: () -> Content) {
        self.title = title
        self.style = style
        self.hasPadding = hasPadding
        self.removeShadow = removeShadow
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if let title = title {
                Text(title + ":")
                    .font(.caption)
                    .fontWeight(.regular)
                    .textCase(.uppercase)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
            }

            VStack(alignment: .center, spacing: 0) { content }
                .background(Color("baseButton"))
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .circular))
                .shadow(color: Color.black.opacity(removeShadow != true && style == .shadow ? 0.15 : 0.0), radius: 15, x: 0, y: 8)
                .overlay(RoundedRectangle(cornerRadius: 15, style: .circular).strokeBorder(DefaultTemplate.borderColor, lineWidth: style == .shadow ? 1.0 : 1.35))
                .padding(.top, 1.5)
                .padding(.bottom, 5)
                .padding(.horizontal, 2)
        }
        .padding(.bottom, hasPadding ?? true ? 20 : 0)
        .padding(.horizontal, hasPadding ?? true ? 20 : 0)
    }
}
