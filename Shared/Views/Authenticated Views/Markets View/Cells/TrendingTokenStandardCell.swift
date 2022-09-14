//
//  TrendingTokenStandardCell.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 4/3/22.
//

import SwiftUI

struct TrendingTokenStandardCell: View {

    @ObservedObject private var service: AuthenticatedServices

    private let data: TrendingItem
    private var isLast: Bool
    private let style: AppStyle
    private let action: () -> Void

    init(service: AuthenticatedServices, data: TrendingItem, isLast: Bool, style: AppStyle, action: @escaping () -> Void) {
        self.service = service
        self.data = data
        self.isLast = isLast
        self.style = style
        self.action = action
    }

    var body: some View {
        ZStack(alignment: .center) {
            Button(action: {
                self.actionTap()
            }, label: {
                VStack(alignment: .trailing, spacing: 0) {
                    HStack(alignment: .top, spacing: 10) {
                        Text("\((data.score ?? -1) + 1)")
                            .fontTemplate(DefaultTemplate.caption_semibold)

                        RemoteImage(data.small ?? "", size: 42)
                            .clipShape(Circle())
                            .overlay(Circle().strokeBorder(DefaultTemplate.borderColor.opacity(1.0), lineWidth: 1))
                            .shadow(color: Color.black.opacity(service.themeStyle == .shadow ? 0.15 : 0.0), radius: 6, x: 0, y: 4)

                        VStack(alignment: .leading, spacing: 0) {
                            Text(data.name ?? "")
                                .fontTemplate(DefaultTemplate.gasPriceFont)
                                .adjustsFontSizeToFitWidth(true)
                                .minimumScaleFactor(0.85)
                                .lineLimit(1)

                            if let symbol = data.symbol?.uppercased() {
                                Text(symbol)
                                    .fontTemplate(DefaultTemplate.body_secondary)
                                    .offset(y: -1.5)
                            }
                        }

                        Spacer()
                        VStack(alignment: .trailing, spacing: 0) {
                            HStack(alignment: .center, spacing: 15) {
                                if let marketCapRank = data.marketCapRank {
                                    Text("#\(marketCapRank)")
                                        .fontTemplate(DefaultTemplate.caption_micro_Mono)
                                        .minimumScaleFactor(0.925)
                                        .padding(.vertical, 1)
                                        .padding(.horizontal, 4)
                                        .opacity(0.85)
                                        .background(RoundedRectangle(cornerRadius: 3, style: .circular)
                                            .foregroundColor(DefaultTemplate.gray5))
                                }

                                Image(systemName: "chevron.right")
                                    .resizable()
                                    .font(Font.title.weight(.bold))
                                    .scaledToFit()
                                    .frame(width: 7, height: 12, alignment: .center)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal)

                    if style == .shadow, !isLast {
                        Divider().padding(.leading, 65)
                    } else if style == .border, !isLast {
                        Rectangle().foregroundColor(DefaultTemplate.borderColor)
                            .frame(height: 1)
                    }
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
            HapticFeedback.lightHapticFeedback()
        #endif

        action()
    }

}
