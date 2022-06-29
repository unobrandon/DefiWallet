//
//  TokenBalanceListCell.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 4/6/22.
//

import SwiftUI

struct TokenBalanceCell: View {

    @ObservedObject private var service: AuthenticatedServices

    private let data: TokenModel
    private var isLast: Bool
    private let style: AppStyle
    private let action: () -> Void

    init(service: AuthenticatedServices, data: TokenModel, isLast: Bool, style: AppStyle, action: @escaping () -> Void) {
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
                    HStack(alignment: .top, spacing: 5) {
                        ZStack {
                            RemoteImage(data.imageSmall ?? data.image ?? "", size: 42)
                                .clipShape(Circle())
                                .overlay(Circle().strokeBorder(DefaultTemplate.borderColor.opacity(0.8), lineWidth: 1))
                                .shadow(color: Color.black.opacity(service.themeStyle == .shadow ? 0.15 : 0.0), radius: 8, x: 0, y: 6)

                            if let net = data.network {
                                Image((net == "bsc" ? "binance" : net) + "_logo")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 18, height: 18, alignment: .center)
                                    .clipShape(Circle())
                                    .overlay(Circle().foregroundColor(.clear).overlay(Circle().stroke(Color("baseBackground_bordered"), lineWidth: 2.5)))
                                    .offset(x: -15, y: 15)
                            }
                        }
                        .padding(.trailing, 7.5)

                        VStack(alignment: .leading, spacing: 0) {
                            HStack(alignment: .center, spacing: 5) {
                                Text(data.name ?? "no name")
                                    .fontTemplate(DefaultTemplate.gasPriceFont)
                                    .lineLimit(2)

                                if let rank = data.marketCapRank {
                                    Text("#\(rank)").fontTemplate(DefaultTemplate.body_secondary_semibold)
                                }
                            }

                            if let native = data.nativeBalance,
                               let roundedValue = native.truncate(places: 3) {
                                HStack(alignment: .center, spacing: 2) {
                                    Text("".forTrailingZero(temp: roundedValue)).fontTemplate(DefaultTemplate.body_secondary_semibold)

                                    Text(data.symbol?.uppercased() ?? "")
                                        .fontTemplate(DefaultTemplate.body_secondary)
                                        .lineLimit(1)
                                }.padding(.trailing, 12)
                            }
                        }

                        Spacer()
                        VStack(alignment: .trailing, spacing: 2) {
                            HStack(alignment: .center, spacing: 10) {
                                Text("\(data.totalBalance?.convertToCurrency() ?? "$0.00")").fontTemplate(DefaultTemplate.gasPriceFont)

                                Image(systemName: "chevron.right")
                                    .resizable()
                                    .font(Font.title.weight(.semibold))
                                    .scaledToFit()
                                    .frame(width: 6, height: 12, alignment: .center)
                                    .foregroundColor(.secondary)
                            }

                            ProminentRoundedLabel(text: (data.priceChangePercentage24H ?? 0 >= 0 ? "+" : "") +
                                                  "\("".forTrailingZero(temp: data.priceChangePercentage24H?.truncate(places: 2) ?? 0.00))%",
                                                  color: data.priceChangePercentage24H ?? 0 >= 0 ? .green : .red,
                                                  fontSize: 13.0,
                                                  style: service.themeStyle).padding(.trailing, 12.5)
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

        }
    }

    private func actionTap() {
        #if os(iOS)
            HapticFeedback.rigidHapticFeedback()
        #endif

        action()
    }
}
