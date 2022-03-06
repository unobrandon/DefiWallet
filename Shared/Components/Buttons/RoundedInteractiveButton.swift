//
//  RoundedInteractiveButton.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/27/22.
//

import SwiftUI

struct RoundedInteractiveButton: View {

    let title: String
    @Binding var isDisabled: Bool
    var action: () -> Void
    let style: Style
    let systemImage: String?

    init(_ title: String, isDisabled: Binding<Bool>, style: Style = .primary, systemImage: String?, action: @escaping () -> Void) {
        self.title = title
        self._isDisabled = isDisabled
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
            .foregroundColor(isDisabled ? .secondary : foregroundColor)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10, style: .circular)
                    .foregroundColor(isDisabled ? DefaultTemplate.disabledGray : backgroundColor))
            .frame(maxWidth: 380, minHeight: 49)
        })
        .buttonStyle(ClickInteractiveStyle())
    }

    private func actionTap() {
        #if os(iOS)
        if isDisabled {
            HapticFeedback.errorHapticFeedback()
        } else {
            HapticFeedback.lightHapticFeedback()
        }
        #endif

        guard !isDisabled else { return }
        action()
    }

}
