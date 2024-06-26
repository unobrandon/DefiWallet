//
//  ListButton.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/26/22.
//

import SwiftUI

struct ListStandardButton: View {

    private let title: String
    private var systemImage: String = ""
    private var localImage: String = ""
    private let isLast: Bool
    private let hasHaptic: Bool?
    private let style: AppStyle
    private let action: () -> Void

    // System Image

    init(title: String, systemImage: String, isLast: Bool, hasHaptic: Bool? = true, style: AppStyle, action: @escaping () -> Void) {
        self.title = title
        self.systemImage = systemImage
        self.isLast = isLast
        self.hasHaptic = hasHaptic
        self.style = style
        self.action = action
    }

    // Local Image

    init(title: String, localImage: String, isLast: Bool, hasHaptic: Bool? = true, style: AppStyle, action: @escaping () -> Void) {
        self.title = title
        self.localImage = localImage
        self.isLast = isLast
        self.hasHaptic = hasHaptic
        self.style = style
        self.action = action
    }

    // Text Only

    init(title: String, isLast: Bool, hasHaptic: Bool? = true, style: AppStyle, action: @escaping () -> Void) {
        self.title = title
        self.isLast = isLast
        self.hasHaptic = hasHaptic
        self.style = style
        self.action = action
    }

    var body: some View {
        ZStack(alignment: .center) {

            Button(action: {
                self.actionTap()
            }, label: {
                VStack(alignment: .trailing, spacing: 0) {
                    HStack(alignment: .center) {
                        if !systemImage.isEmpty {
                            Image(systemName: systemImage)
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.primary)
                                .frame(width: 20, height: 20, alignment: .center)
                                .padding(.trailing, 5)
                        } else if !localImage.isEmpty {
                            Image(localImage)
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(Color.primary)
                                .frame(width: 20, height: 20, alignment: .center)
                                .padding(.trailing, 5)
                                .padding(.vertical, 5)
                        } else {
                            EmptyView().frame(height: 20)
                        }

                        Text(title)
                            .fontTemplate(DefaultTemplate.body)
                            .lineLimit(2)

                        Spacer()
                        Image(systemName: "chevron.right")
                            .resizable()
                            .font(Font.title.weight(.bold))
                            .scaledToFit()
                            .frame(width: 7, height: 15, alignment: .center)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, localImage.isEmpty ? 15 : 10)

                    if style == .shadow, !isLast {
                        Divider()
                            .padding(.leading, (localImage.isEmpty && systemImage.isEmpty ? 20 : (localImage.isEmpty ? 50 : 65)))
                    } else if style == .border, !isLast {
                        Rectangle().foregroundColor(DefaultTemplate.borderColor)
                            .frame(height: 1)
                    }

                }
                .contentShape(Rectangle())
            })
            .buttonStyle(DefaultInteractiveStyle(style: self.style))
            .frame(minWidth: 100, maxWidth: .infinity)

        }
    }

    private func actionTap() {
        #if os(iOS)
            HapticFeedback.rigidHapticFeedback()
        #endif

        action()
    }
}
