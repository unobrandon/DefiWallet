//
//  ListButtonHeader.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 3/14/22.
//

import SwiftUI

struct ListButtonHeader: View {

    private let name: String
    private var localImage: String = ""
    private let hasHaptic: Bool?
    private let style: AppStyle
    private let action: () -> Void

    init(name: String, localImage: String, hasHaptic: Bool? = true, style: AppStyle, action: @escaping () -> Void) {
        self.name = name
        self.localImage = localImage
        self.hasHaptic = hasHaptic
        self.style = style
        self.action = action
    }

    var body: some View {
        ZStack(alignment: .center) {

            Button(action: { self.actionTap() }) {
                VStack(alignment: .trailing, spacing: 0) {
                    HStack(alignment: .center) {
                        Image(localImage)
                            .resizable()
                            .scaledToFill()
                            .foregroundColor(Color.primary)
                            .frame(width: 48, height: 48, alignment: .center)
                            .clipShape(Circle())
                            .padding(.trailing, 5)

                        VStack(alignment: .leading, spacing: 1) {
                            Text(name)
                                .fontTemplate(DefaultTemplate.bodyMono)

                            Text("edit account")
                                .fontTemplate(DefaultTemplate.bodyMedium_accent_standard)
                        }

                        Spacer()
                        Image(systemName: "chevron.right")
                            .resizable()
                            .font(Font.title.weight(.bold))
                            .scaledToFit()
                            .frame(width: 7, height: 15, alignment: .center)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(DefaultInteractiveStyle(style: self.style))
            .frame(minWidth: 100, maxWidth: .infinity)

        }.simultaneousGesture(TapGesture().onEnded {
            #if os(iOS)
                HapticFeedback.rigidHapticFeedback()
            #endif
        })
    }

    private func actionTap() {
        #if os(iOS)
            HapticFeedback.lightHapticFeedback()
        #endif

        action()
    }
}
