//
//  ExchangePairCell.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 6/13/22.
//

import SwiftUI

struct ExchangePairCell: View {

    @ObservedObject private var service: AuthenticatedServices

    private let data: ExchangeTicker
    private var isLast: Bool
    private let style: AppStyle
    private let action: () -> Void

    init(service: AuthenticatedServices, data: ExchangeTicker, isLast: Bool, style: AppStyle, action: @escaping () -> Void) {
        self.service = service
        self.data = data
        self.isLast = isLast
        self.style = style
        self.action = action
    }

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Button(action: {
                self.actionTap()
            }, label: {
                HStack(alignment: .center, spacing: 5) {
                    if let base = data.base {
                        Text(base).fontTemplate(DefaultTemplate.bodyBold)
                    }

                    Image(systemName: "arrow.left.arrow.right")
                        .resizable()
                        .font(Font.title.weight(.semibold))
                        .scaledToFit()
                        .frame(width: 16, height: 14, alignment: .center)
                        .foregroundColor(.primary)

                    if let target = data.target {
                        Text(target).fontTemplate(DefaultTemplate.bodyBold)
                    }

                    Spacer()
                    HStack(alignment: .top, spacing: 10) {
                        VStack(alignment: .trailing, spacing: 0) {
                            if service.currentUser.currency == "usd", let price = data.last {
                                Text("$\("".formatLargeDoubleNumber(price, size: .small, scale: 2))").fontTemplate(DefaultTemplate.bodyMedium)
                            } else if let btc = data.convertedLast?.first {
                                Text("\("".formatLargeDoubleNumber(btc.value, size: .small, scale: 2)) \(btc.key.uppercased())").fontTemplate(DefaultTemplate.bodyMedium)
                            }

                            if let volume = data.volume {
                                Text("$\("".formatLargeDoubleNumber(volume, size: .small, scale: 2)) volume")
                                    .fontTemplate(DefaultTemplate.caption)
                            } else if let btc = data.convertedVolume?.first {
                                Text("\("".formatLargeDoubleNumber(btc.value, size: .small, scale: 2)) \(btc.key.uppercased()) volume").fontTemplate(DefaultTemplate.caption)
                            }
                        }

                        Image(systemName: "chevron.right")
                            .resizable()
                            .font(Font.title.weight(.regular))
                            .scaledToFit()
                            .frame(width: 7, height: 12, alignment: .center)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                .contentShape(Rectangle())
            })
            .buttonStyle(DefaultInteractiveStyle(style: self.style))
            .frame(minWidth: 100, maxWidth: .infinity)

            if style == .shadow, !isLast {
                Divider().padding(.leading, 20)
            } else if style == .border, !isLast {
                Rectangle().foregroundColor(DefaultTemplate.borderColor)
                    .frame(height: 1)
            }
        }
    }

    private func actionTap() {
        #if os(iOS)
            HapticFeedback.rigidHapticFeedback()
        #endif

        action()
    }

}
