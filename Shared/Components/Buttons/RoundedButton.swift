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
    let removePadding: Bool

    init(_ title: String, style: Style = .primary, systemImage: String?, removePadding: Bool? = nil, action: @escaping () -> Void) {
        self.title = title
        self.style = style
        self.systemImage = systemImage ?? nil
        self.removePadding = removePadding ?? false
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
            HStack(alignment: .center, spacing: 10) {
                Spacer()
                if let systemImage = systemImage {
                    Image(systemName: systemImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20, alignment: .center)
                        .font(Font.title.weight(.medium))
                }

                Text(title)
                    .fontTemplate(FontTemplate(font: Font.custom("Poppins-Medium", size: 16), weight: .medium, foregroundColor: foregroundColor, lineSpacing: 0))

                Spacer()
            }
            .background(RoundedRectangle(cornerRadius: 10, style: .circular)
                            .foregroundColor(backgroundColor).frame(height: 49))
            .foregroundColor(foregroundColor)
        })
        .padding(.horizontal, removePadding ? 0 : 20)
        .frame(maxWidth: 380)
        .buttonStyle(ClickInteractiveStyle(0.99))
    }

    private func actionTap() {
        #if os(iOS)
            HapticFeedback.lightHapticFeedback()
        #endif

        action()
    }

}
