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
        Button(action: {
            action()

            #if os(iOS)
                HapticFeedback.rigidHapticFeedback()
            #endif
        }, label: {
            HStack(alignment: .center, spacing: 10) {
                Image(systemName: systemImage)
                    .resizable()
                    .sizeToFit()
                    .frame(height: size * 0.5, alignment: .center)

                Text(title)
                    .fontTemplate(FontTemplate(font: Font.custom("Poppins-Medium", size: 16), weight: .medium, foregroundColor: style == .shadow ? Color.white : Color("AccentColor"), lineSpacing: 1))
                    .lineLimit(1)
            }
            .foregroundColor(style == .shadow ? Color.white : Color("AccentColor"))
            .frame(maxWidth: .infinity)
            .background(RoundedRectangle(cornerRadius: 10, style: .circular)
                .foregroundColor(Color("AccentColor").opacity(style == .shadow ? 1.0 : 0.15)).frame(height: size).frame(maxWidth: .infinity))
            .shadow(color: Color("AccentColor").opacity(style == .shadow ? 0.175 : 0.0),
                    radius: size > 40 ? (size / 7) : size < 25 ? 3 : 5, x: 0, y: size > 40 ? (size / 8) : size < 25 ? 3 : 5)
        })
        .buttonStyle(ClickInteractiveStyle(0.95))
        .padding(.bottom, 20)
    }

}
