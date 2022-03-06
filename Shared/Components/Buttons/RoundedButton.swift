//
//  RoundedButton.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/13/22.
//

import Foundation
import SwiftUI

struct RoundedButton: View {

    let title: String
    var action: () -> Void
    let style: Style
    let systemImage: String?

    init(_ title: String, style: Style = .primary, systemImage: String?, action: @escaping () -> Void) {
        self.title = title
        self.style = style
        self.systemImage = systemImage ?? nil
        self.action = action
    }

    enum Style: Equatable {
        case primary
        case secondary
        case bordered
    }

    var foregroundColor: Color {
        switch style {
        case .primary:
            return .white
        case .secondary:
            return Color.black
        case .bordered:
            return Color.primary
        }
    }

    var backgroundColor: Color {
        switch style {
        case .primary:
            return Color("AccentColor")
        case .secondary:
            return Color(red: 0.8, green: 0.8, blue: 0.8)
        case .bordered:
            return Color.clear
        }
    }

    var body: some View {
        #if targetEnvironment(macCatalyst)
        standardView
        #elseif os(macOS)
        standardView
        #elseif os(iOS)
        iosView
        #else
        standardView
        #endif
    }

    var standardView: some View {
        Button(title) {
            action()
        }
    }

    var iosView: some View {
        Button(action: { self.actionTap() }, label: {
            HStack {
                Spacer()
                if let systemImage = systemImage {
                    Image(systemName: systemImage)
                }
                Text(title).font(.headline)
                Spacer()
            }
            .foregroundColor(foregroundColor)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10, style: .circular)
                    .foregroundColor(backgroundColor))
            .frame(maxWidth: 380, minHeight: 49)
        })
        .buttonStyle(ClickInteractiveStyle())
    }

    private func actionTap() {
        #if os(iOS)
            HapticFeedback.lightHapticFeedback()
        #endif

        action()
    }

}
