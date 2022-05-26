//
//  TokenDetailsHeaderSection.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 5/24/22.
//

import SwiftUI

struct TokenDetailsHeaderSection: View {

    @ObservedObject private var service: AuthenticatedServices

    @State private var tokenDetail: TokenDetails?
    @State private var tokenDescriptor: TokenDescriptor?

    init(tokenDetail: TokenDetails?, tokenDescriptor: TokenDescriptor?, service: AuthenticatedServices) {
        self.service = service
        self.tokenDetail = tokenDetail
        self.tokenDescriptor = tokenDescriptor
    }

    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            VStack(alignment: .leading, spacing: 0) {
                RemoteImage(tokenDescriptor?.imageLarge, size: 44)
                    .clipShape(Circle())
                    .overlay(Circle().strokeBorder(DefaultTemplate.borderColor.opacity(1.0), lineWidth: 1.0))
                    .shadow(color: Color.black.opacity(service.themeStyle == .shadow ? 0.15 : 0.0), radius: 4, x: 0, y: 2)
                    .padding(.vertical, 5)

                HStack(alignment: .center, spacing: 5) {
                    Text(tokenDescriptor?.name ?? tokenDetail?.name ?? "").fontTemplate(DefaultTemplate.sectionHeader)

                    Text(tokenDescriptor?.symbol?.uppercased() ?? tokenDetail?.symbol?.uppercased() ?? "").fontTemplate(DefaultTemplate.sectionHeader_secondary)
                }

                HStack(alignment: .center, spacing: 0) {
                    Text(Locale.current.currencySymbol ?? "").fontTemplate(DefaultTemplate.titleSemiBold)

                    MovingNumbersView(number: tokenDetail?.currentPrice ?? 0.00,
                                      numberOfDecimalPlaces: tokenDetail?.currentPrice?.decimalCount() ?? 2 < 2 ? 2 : tokenDetail?.currentPrice?.decimalCount() ?? 2,
                                      fixedWidth: 260,
                                      animationDuration: 0.4,
                                      showComma: true) { str in
                        Text(str).fontTemplate(DefaultTemplate.titleSemiBold)
                    }
                }.mask(AppGradients.movingNumbersMask)

                HStack(alignment: .center, spacing: 5) {
                    if let change = tokenDetail?.priceChangePercentage24H {
                        ProminentRoundedLabel(text: (change >= 0 ? "+" : "") +
                                              "\("".forTrailingZero(temp: change.truncate(places: 2)))%",
                                              color: change >= 0 ? .green : .red,
                                              style: service.themeStyle)

                        if let change = tokenDetail?.priceChange24H,
                           let isPositive = change >= 0 {
                            Text("\(change)")
                                .fontTemplate(FontTemplate(font: Font.system(size: 14.0), weight: .semibold, foregroundColor: isPositive ? .green : .red, lineSpacing: 0))
                        }
                    }
                }
            }
            Spacer()
        }
        .padding(.horizontal)
    }

}
