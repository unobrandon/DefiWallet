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

                let socketChart = walletStore.tokenDetailChart?.last?.last
                let num = socketChart ?? tokenModel?.currentPrice ?? tokenDetails?.currentPrice ?? 0.00
                MovingNumbersView(number: num,
                                  numberOfDecimalPlaces: socketChart?.decimalCount() ?? tokenModel?.currentPrice?.decimalCount() ?? tokenDetails?.currentPrice?.decimalCount() ?? 2 < 2 ? 2 : tokenModel?.currentPrice?.decimalCount() ?? tokenDetails?.currentPrice?.decimalCount() ?? 2,
                                  fixedWidth: nil,
                                  theme: DefaultTemplate.titleSemiBold,
                                  animationDuration: 0.4,
                                  showComma: true) { str in
                    Text(str).fontTemplate(DefaultTemplate.titleSemiBold)
                }
                Spacer()
            }.mask(AppGradients.movingNumbersMask)

            HStack(alignment: .center, spacing: 5) {
                if let change = tokenModel?.priceChangePercentage24H ?? tokenDetails?.priceChangePercentage24H {
                    ProminentRoundedLabel(text: (change >= 0 ? "+" : "") +
                                          "\("".forTrailingZero(temp: change.reduceScale(to: 3)))%",
                                          color: change >= 0 ? .green : .red,
                                          style: service.themeStyle)
                }

                if let priceChange = tokenModel?.priceChange24H ?? tokenDetails?.priceChange24H,
                   let isPositive = priceChange >= 0 {
                    Text("\(isPositive ? "+" : "-")\(Locale.current.currencySymbol ?? "")\(Int(priceChange))")
                        .fontTemplate(FontTemplate(font: Font.system(size: 14.0), weight: .semibold, foregroundColor: isPositive ? .green : .red, lineSpacing: 0))
                }
                Spacer()
            }
        }
        .padding(.horizontal)
    }

}
