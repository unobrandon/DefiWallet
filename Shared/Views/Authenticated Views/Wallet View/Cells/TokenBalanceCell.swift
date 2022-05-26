//
//  TokenBalanceListCell.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 4/6/22.
//

import SwiftUI

struct TokenBalanceCell: View {

    @ObservedObject private var service: AuthenticatedServices

    private let data: TokenBalance
    private let network: String
    private var isLast: Bool
    private let style: AppStyle
    private let action: () -> Void

    init(service: AuthenticatedServices, data: TokenBalance, network: String, isLast: Bool, style: AppStyle, action: @escaping () -> Void) {
        self.service = service
        self.data = data
        self.network = network
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
                    HStack(alignment: .center, spacing: 10) {
                        ZStack {
                            RemoteImage(data.thumbnail ?? data.logo ?? "", size: 42)
                                .clipShape(Circle())
                                .overlay(Circle().strokeBorder(DefaultTemplate.borderColor.opacity(0.8), lineWidth: 1))
                                .shadow(color: Color.black.opacity(service.themeStyle == .shadow ? 0.15 : 0.0), radius: 8, x: 0, y: 6)

                            Image((network == "bsc" ? "binance" : network) + "_logo")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 18, height: 18, alignment: .center)
                                .clipShape(Circle())
                                .overlay(Circle().foregroundColor(.clear).overlay(Circle().stroke(Color("baseBackground_bordered"), lineWidth: 2.5)))
                                .offset(x: -15, y: 15)
                        }

                        VStack(alignment: .leading, spacing: 0) {
                            // Upper details
                            HStack(alignment: .center, spacing: 10) {
                                Text(data.name ?? "no name")
                                    .fontTemplate(DefaultTemplate.subheadingMedium)
                                    .lineLimit(1)

                                Spacer()
                                Text("$\(data.usdTotal ?? "0.00")").fontTemplate(DefaultTemplate.gasPriceFont)

                                Image(systemName: "chevron.right")
                                    .resizable()
                                    .font(Font.title.weight(.semibold))
                                    .scaledToFit()
                                    .frame(width: 6, height: 12, alignment: .center)
                                    .foregroundColor(.secondary)
                            }

                            // Lower details
                            HStack(alignment: .center, spacing: 10) {
                                if let native = data.balance,
                                   let balance = Double(native),
                                   let formatted = (balance / Constants.eighteenDecimal),
                                   let roundedValue = formatted.truncate(places: 3) {
                                    HStack(alignment: .center, spacing: 2) {
                                        Text("".forTrailingZero(temp: roundedValue)).fontTemplate(DefaultTemplate.caption_semibold)

                                        Text(data.symbol ?? "").fontTemplate(DefaultTemplate.caption)
                                    }
                                }

                                Spacer()
                                ProminentRoundedLabel(text: "2.41%",
                                                      color: .green,
                                                      style: service.themeStyle)
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
