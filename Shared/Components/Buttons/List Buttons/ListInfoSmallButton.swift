//
//  ListInfoSmallButton.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 8/27/22.
//

import SwiftUI

struct ListInfoSmallButton: View {

    private let title: String
    private let info: String
    private let subinfo: String?
    private var systemImage: String = ""
    private var actionSystemImage: String?
    private var localImage: String = ""
    private let isLast: Bool
    private let hasHaptic: Bool?
    private let style: AppStyle
    private let action: () -> Void

    // System Image

    init(title: String, info: String?, subinfo: String?, systemImage: String, isLast: Bool, hasHaptic: Bool? = true, style: AppStyle, action: @escaping () -> Void) {
        self.title = title
        self.info = info ?? ""
        self.subinfo = subinfo
        self.systemImage = systemImage
        self.isLast = isLast
        self.hasHaptic = hasHaptic
        self.style = style
        self.action = action
    }

    // Local Image

    init(title: String, info: String?, subinfo: String?, localImage: String, isLast: Bool, hasHaptic: Bool? = true, style: AppStyle, action: @escaping () -> Void) {
        self.title = title
        self.info = info ?? ""
        self.subinfo = subinfo
        self.localImage = localImage
        self.isLast = isLast
        self.hasHaptic = hasHaptic
        self.style = style
        self.action = action
    }

    // Text Only

    init(title: String, info: String?, subinfo: String?, actionSystemImage: String? = "", isLast: Bool, hasHaptic: Bool? = true, style: AppStyle, action: @escaping () -> Void) {
        self.title = title
        self.info = info ?? ""
        self.subinfo = subinfo
        self.actionSystemImage = actionSystemImage ?? ""
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
                                .foregroundColor(.secondary)
                                .frame(width: 15, height: 15, alignment: .center)
                                .padding(.trailing, 2)
                        } else if !localImage.isEmpty {
                            Image(localImage)
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.secondary)
                                .frame(width: 26, height: 26, alignment: .center)
                                .padding(.trailing, 2)
                        } else {
                            EmptyView().frame(height: 10)
                        }

                        Text(title).fontTemplate(DefaultTemplate.caption_semibold)
                        Spacer()

                        HStack(alignment: .center, spacing: 10) {
                            if let subinfo = subinfo {
                                Text(subinfo)
                                    .fontTemplate(DefaultTemplate.bodySemibold_nunito_secondary)
                            }

                            Text(info)
                                .fontTemplate(DefaultTemplate.bodySemibold_standard)
                        }
                        .padding(.trailing, actionSystemImage?.isEmpty ?? true ? 5 : 2)

                        Image(systemName: actionSystemImage ?? "chevron.right")
                            .resizable()
                            .font(Font.title.weight(.bold))
                            .scaledToFit()
                            .frame(width: actionSystemImage?.isEmpty ?? true ? 7 : 15, height: 15, alignment: .center)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, localImage.isEmpty ? 12.5 : 7.5)

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
