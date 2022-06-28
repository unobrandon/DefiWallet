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
                RemoteImage(tokenDescriptor?.imageLarge ?? tokenModel?.image, size: 48)
                    .clipShape(Circle())
                    .overlay(Circle().strokeBorder(DefaultTemplate.borderColor.opacity(1.0), lineWidth: 1.0))
                    .shadow(color: Color.black.opacity(service.themeStyle == .shadow ? 0.15 : 0.0), radius: 5, x: 0, y: 4)
                    .padding(.vertical, 5)

                VStack(alignment: .leading, spacing: 0) {
                    Text(tokenDescriptor?.name ?? tokenModel?.name ?? "").fontTemplate(DefaultTemplate.subheadingSemiBold)

                    Text("#\(tokenDescriptor?.marketCapRank ?? 0) " + (tokenDescriptor?.symbol?.uppercased() ?? tokenModel?.symbol?.uppercased() ?? ""))
                        .fontTemplate(DefaultTemplate.sectionHeader_secondary)
                }
                Spacer()
            }
            .padding(.bottom, 10)

            HStack(alignment: .center, spacing: 0) {
                Text(Locale.current.currencySymbol ?? "").fontTemplate(DefaultTemplate.titleSemiBold)

                MovingNumbersView(number: tokenModel?.currentPrice ?? 0.00,
                                  numberOfDecimalPlaces: tokenModel?.currentPrice?.decimalCount() ?? 2 < 2 ? 2 : tokenModel?.currentPrice?.decimalCount() ?? 2,
                                  fixedWidth: nil,
                                  animationDuration: 0.4,
                                  showComma: true) { str in
                    Text(str).fontTemplate(DefaultTemplate.titleSemiBold)
                }
                Spacer()
            }.mask(AppGradients.movingNumbersMask)

            HStack(alignment: .center, spacing: 5) {
                if let change = tokenModel?.priceChangePercentage24H {
                    ProminentRoundedLabel(text: (change >= 0 ? "+" : "") +
                                          "\("".forTrailingZero(temp: change.reduceScale(to: 3)))%",
                                          color: change >= 0 ? .green : .red,
                                          style: service.themeStyle)
                }

                if let priceChange = tokenModel?.priceChange24H,
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
