//
//  TokenListStandardCell.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 3/24/22.
//

import SwiftUI

struct TokenListStandardCell: View {

    @ObservedObject private var service: AuthenticatedServices

    private let data: TokenDetails
    private var isLast: Bool
    private let style: AppStyle
    private let action: () -> Void

    init(service: AuthenticatedServices, data: TokenDetails, isLast: Bool, style: AppStyle, action: @escaping () -> Void) {
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
                    HStack(alignment: .center, spacing: 0) {
                        RemoteImage(data.image ?? "", size: 44)
                            .clipShape(Circle())
                            .overlay(Circle().strokeBorder(DefaultTemplate.borderColor.opacity(0.75), lineWidth: 1))
                            .shadow(color: Color.black.opacity(service.themeStyle == .shadow ? 0.15 : 0.0), radius: 6, x: 0, y: 4)

                        VStack(alignment: .leading, spacing: 0) {
                            Text(data.name ?? "no name")
                                .fontTemplate(DefaultTemplate.gasPriceFont)
                                .adjustsFontSizeToFitWidth(true)
                                .minimumScaleFactor(0.85)
                                .lineLimit(1)

                            HStack(alignment: .center, spacing: 5) {
                                if let rank = data.marketCapRank {
                                    Text("#\(rank)")
                                        .fontTemplate(DefaultTemplate.caption_micro_Mono)
                                        .minimumScaleFactor(0.925)
                                        .padding(.vertical, 1)
                                        .padding(.horizontal, 4)
                                        .opacity(0.85)
                                        .background(RoundedRectangle(cornerRadius: 3, style: .circular)
                                            .foregroundColor(DefaultTemplate.gray5))
                                }

                                if let symbol = data.symbol?.uppercased() {
                                    Text(symbol)
                                        .fontTemplate(DefaultTemplate.body_secondary)
                                        .offset(y: -1.5)
                                }
                            }
                        }.padding(.leading, 10)

                        Spacer()

                        if let chart = data.priceGraph?.price, data.name?.count ?? 0 <= 15 {
                            // stride(from: 1, to: store.accountChart.count - 1, by: 4).map({ store.accountChart[$0].amount })
                            LightChartView(data: stride(from: 0, to: chart.count, by: 4).map({ chart[$0] }),
                                           type: .curved,
                                           visualType: .outline(color: data.priceChangePercentage24H ?? 0.0 >= 0.0 ? .green : .red, lineWidth: 1.8),
                                           offset: 0.2,
                                           currentValueLineType: .none)
                                    .frame(width: 50, height: 30, alignment: .center)
                                    .padding(.trailing, 10)
                        }

                        VStack(alignment: .trailing, spacing: 2.5) {
                            HStack(alignment: .center, spacing: 10) {
                                HStack(alignment: .center, spacing: 1) {
                                    if let num = Double("".forTrailingZero(temp: data.currentPrice?.truncate(places: 4) ?? 0.00)) {
                                        Text(Locale.current.currencySymbol ?? "").fontTemplate(DefaultTemplate.bodySemibold)

                                        MovingNumbersView(number: num,
                                                          numberOfDecimalPlaces: 2,
                                                          fixedWidth: nil,
                                                          showComma: true) { str in
                                            Text(str).fontTemplate(DefaultTemplate.bodySemibold)
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
                                                  fontSize: 13.0,
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

        }
    }

    private func actionTap() {
        #if os(iOS)
            HapticFeedback.rigidHapticFeedback()
        #endif

        action()
    }

}
