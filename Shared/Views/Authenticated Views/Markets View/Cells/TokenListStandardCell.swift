//
//  TokenListStandardCell.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 3/24/22.
//

import SwiftUI

struct TokenListStandardCell: View {

    @ObservedObject private var service: AuthenticatedServices

    private let data: CoinMarketCap
    private var isLast: Bool
    private let style: AppStyle
    private let action: () -> Void

    init(service: AuthenticatedServices, data: CoinMarketCap, isLast: Bool, style: AppStyle, action: @escaping () -> Void) {
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
                        Text("\(data.marketCapRank ?? 0)")
                            .fontTemplate(DefaultTemplate.caption_semibold)

                        RemoteImage(imageUrl: data.image ?? "", size: 36)
                            .padding(.trailing, 5)

                        VStack(alignment: .leading, spacing: 0) {
                            Text(data.name ?? "").fontTemplate(DefaultTemplate.gasPriceFont)
                            Text(data.symbol ?? "").fontTemplate(DefaultTemplate.body_secondary)
                        }

                        Spacer()
                        VStack(alignment: .trailing, spacing: 0) {
                            HStack(alignment: .center, spacing: 10) {
                                Text("$\("".forTrailingZero(temp: data.currentPrice?.truncate(places: 4) ?? 0.00))").fontTemplate(DefaultTemplate.gasPriceFont)

                                Image(systemName: "chevron.right")
                                    .resizable()
                                    .font(Font.title.weight(.bold))
                                    .scaledToFit()
                                    .frame(width: 7, height: 12, alignment: .center)
                                    .foregroundColor(.secondary)
                            }

                            ProminentRoundedLabel(text: (data.priceChangePercentage24H ?? 0 >= 0 ? "+" : "") + "\("".forTrailingZero(temp: data.priceChangePercentage24H?.truncate(places: 2) ?? 0.00))%",
                                                  color: data.priceChangePercentage24H ?? 0 >= 0 ? .green : .red,
                                                  style: service.themeStyle)
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
