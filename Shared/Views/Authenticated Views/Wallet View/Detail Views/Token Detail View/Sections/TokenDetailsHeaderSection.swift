//
//  TokenDetailsHeaderSection.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 5/24/22.
//

import SwiftUI

extension TokenDetailView {

    @ViewBuilder
    func detailsHeaderSection() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .center, spacing: 10) {
                RemoteImage(tokenDescriptor?.imageLarge ?? tokenModel?.image ?? tokenDetails?.image, size: 54)
                    .clipShape(Circle())
                    .overlay(Circle().strokeBorder(DefaultTemplate.borderColor.opacity(1.0), lineWidth: 1.0))
                    .shadow(color: Color.black.opacity(service.themeStyle == .shadow ? 0.15 : 0.0), radius: 5, x: 0, y: 4)
                    .padding(.vertical, 5)

                VStack(alignment: .leading, spacing: 0) {
                    Text(tokenDescriptor?.name ?? tokenModel?.name ?? tokenDetails?.name ?? "")
                        .fontTemplate(DefaultTemplate.headingSemiBold)
                        .adjustsFontSizeToFitWidth(true)
                        .minimumScaleFactor(0.75)
                        .lineLimit(1)

                    HStack(alignment: .center, spacing: 5) {
                        if let rank = tokenDescriptor?.marketCapRank ?? tokenDetails?.marketCapRank ?? tokenModel?.marketCapRank {
                            Text("#\(rank)")
                                .fontTemplate(DefaultTemplate.caption_Mono)
                                .minimumScaleFactor(0.925)
                                .padding(.vertical, 1)
                                .padding(.horizontal, 4.5)
                                .opacity(0.85)
                                .background(RoundedRectangle(cornerRadius: 3, style: .circular)
                                    .foregroundColor(DefaultTemplate.gray5))
                        }

                        Text(tokenDescriptor?.symbol?.uppercased() ?? tokenModel?.symbol?.uppercased() ?? tokenDetails?.symbol?.uppercased() ?? "")
                            .fontTemplate(DefaultTemplate.body_standard)
                    }
                }
                Spacer()
            }
            .padding(.bottom, 10)

            HStack(alignment: .center, spacing: 0) {
                Text(Locale.current.currencySymbol ?? "").fontTemplate(DefaultTemplate.titleSemiBold)

                let socketPrice = walletStore.tokenDetailPrice
                let num = socketPrice ?? tokenModel?.currentPrice ?? tokenDetails?.currentPrice ?? 0.00
                MovingNumbersView(number: num,
                                  numberOfDecimalPlaces: socketPrice?.decimalCount() ?? tokenModel?.currentPrice?.decimalCount() ?? tokenDetails?.currentPrice?.decimalCount() ?? 2 < 2 ? 2 : tokenModel?.currentPrice?.decimalCount() ?? tokenDetails?.currentPrice?.decimalCount() ?? 2,
                                  fixedWidth: nil,
                                  theme: DefaultTemplate.titleSemiBold,
                                  animationDuration: 0.4,
                                  showComma: true) { str in
                    Text(str).fontTemplate(DefaultTemplate.titleSemiBold)
                }
                Spacer()
            }.mask(AppGradients.movingNumbersMask)

            HStack(alignment: .center, spacing: 5) {
                if let priceChange = (tokenChart.last?.amount ?? 0.0) - (walletStore.tokenDetailPrice ?? tokenChart.first?.amount ?? 0.0),
                   let isPositive = priceChange >= 0 {
                    Text(priceChange.convertToCurrency())
                        .fontTemplate(FontTemplate(font: Font.system(size: 14.0), weight: .semibold, foregroundColor: isPositive ? .green : .red, lineSpacing: 0))

                    if let change = (priceChange / (walletStore.tokenDetailPrice ?? tokenChart.first?.amount ?? 0.0)) * 100 {
                        ProminentRoundedLabel(text: (change >= 0 ? "+" : "") +
                                              "\("".forTrailingZero(temp: change.reduceScale(to: 3)))%",
                                              color: isPositive ? .green : .red,
                                              fontSize: 12.0,
                                              style: service.themeStyle)
                    }
                }
                Spacer()
            }
        }
        .padding(.horizontal)
    }

}
