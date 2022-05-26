//
//  ListButtonHeader.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 3/14/22.
//

import SwiftUI
import RealmSwift

struct ProfileHeaderButton: View {

    private let name: String
    private var localImage: String = ""
    private let hasHaptic: Bool?
    private let style: AppStyle
    private let user: CurrentUser
    private let action: () -> Void

    init(name: String, hasHaptic: Bool? = true, style: AppStyle, user: CurrentUser, action: @escaping () -> Void) {
        self.name = name
        self.hasHaptic = hasHaptic
        self.style = style
        self.user = user
        self.action = action
    }

    var body: some View {
        ZStack(alignment: .center) {
            Button(action: {
                self.actionTap()
            }, label: {
                VStack(alignment: .trailing, spacing: 0) {
                    HStack(alignment: .center) {
                        UserAvatar(size: 48, user: user, style: style)
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
            })
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
            if hasHaptic ?? true {
                HapticFeedback.lightHapticFeedback()
            }
        #endif

        action()
    }
}
