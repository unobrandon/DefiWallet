//
//  TransactButton.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 3/15/22.
//

import SwiftUI
import SwiftUIX

struct TransactButton: View {

    private let title: String
    private var systemImage: String
    private let size: Double
    private var style: AppStyle
    private let action: () -> Void

    init(title: String, systemImage: String, size: Double, style: AppStyle, action: @escaping () -> Void) {
        self.title = title
        self.systemImage = systemImage
        self.size = size
        self.style = style
        self.action = action
    }

    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Button(action: {
                action()

                #if os(iOS)
                    HapticFeedback.rigidHapticFeedback()
                #endif
            }, label: {
                Image(systemName: systemImage)
                    .resizable()
                    .sizeToFit()
                    .frame(width: size * 0.5, height: size * 0.5, alignment: .center)
                    .foregroundColor(style == .shadow ? Color.white : Color("AccentColor"))
                    .background(RoundedRectangle(cornerRadius: 10, style: .circular)
                                    .foregroundColor(Color("AccentColor").opacity(style == .shadow ? 1.0 : 0.15)).frame(width: size * 1.4, height: size))
                    .shadow(color: Color("AccentColor").opacity(style == .shadow ? 0.175 : 0.0),
                            radius: size > 40 ? (size / 7) : size < 25 ? 3 : 5, x: 0, y: size > 40 ? (size / 8) : size < 25 ? 3 : 5)
            })
            .buttonStyle(ClickInteractiveStyle(0.933))

            Text(title)
                .fontTemplate(DefaultTemplate.bodyMedium_accent_standard)
                .lineLimit(1)
                .frame(width: size * 1.4)
        }
    }

}
