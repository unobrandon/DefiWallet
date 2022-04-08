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
                    HStack(alignment: .top, spacing: 5) {
                        Text("\(data.marketCapRank ?? 0)")
                            .fontTemplate(DefaultTemplate.caption_semibold)

                        RemoteImage(data.image ?? "", size: 36)
                            .clipShape(Circle())
                            .overlay(Circle().strokeBorder(DefaultTemplate.borderColor.opacity(1.0), lineWidth: 1))
                            .shadow(color: Color.black.opacity(service.themeStyle == .shadow ? 0.15 : 0.0), radius: 8, x: 0, y: 6)

                        VStack(alignment: .leading, spacing: 0) {
                            Text(data.name ?? "").fontTemplate(DefaultTemplate.gasPriceFont)
                            Text(data.symbol ?? "").fontTemplate(DefaultTemplate.body_secondary).offset(y: -1.5)
                        }.padding(.leading, 2.5)

                        Spacer()
                        VStack(alignment: .trailing, spacing: 5) {
                            HStack(alignment: .center, spacing: 10) {
                                HStack(alignment: .center, spacing: 1) {
                                    if let num = Double("".forTrailingZero(temp: data.currentPrice?.truncate(places: 4) ?? 0.00)) {
                                        Text("$").fontTemplate(DefaultTemplate.bodyBold)

                                        MovingNumbersView(number: num,
                                                          numberOfDecimalPlaces: 2,
                                                          fixedWidth: nil,
                                                          showComma: true) { str in
                                            Text(str).fontTemplate(DefaultTemplate.bodyMedium)
                                        }
                                    }
                                }.mask(AppGradients.movingNumbersMask)

                                Image(systemName: "chevron.right")
                                    .resizable()
                                    .font(Font.title.weight(.bold))
                                    .scaledToFit()
                                    .frame(width: 7, height: 12, alignment: .center)
                                    .foregroundColor(.secondary)
                            }

                            ProminentRoundedLabel(text: (data.priceChangePercentage24H ?? 0 >= 0 ? "+" : "") +
                                                  "\("".forTrailingZero(temp: data.priceChangePercentage24H?.truncate(places: 2) ?? 0.00))%",
                                                  color: data.priceChangePercentage24H ?? 0 >= 0 ? .green : .red,
                                                  style: service.themeStyle)
                                .padding(.trailing, 12)

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
