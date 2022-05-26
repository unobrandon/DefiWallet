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
        VStack(alignment: .center, spacing: 0) {
            HStack(alignment: .center, spacing: 10) {
                RemoteImage(tokenDescriptor?.imageLarge, size: 50)
                    .clipShape(Circle())
                    .overlay(Circle().strokeBorder(DefaultTemplate.borderColor.opacity(1.0), lineWidth: 1.0))
                    .shadow(color: Color.black.opacity(service.themeStyle == .shadow ? 0.15 : 0.0), radius: 4, x: 0, y: 2)
                    .padding(.vertical, 5)
                
                VStack(alignment: .leading, spacing: 0) {
                    Text(tokenDescriptor?.name ?? tokenDetail?.name ?? "").fontTemplate(DefaultTemplate.subheadingSemiBold)
                    
                    Text("#\(tokenDescriptor?.marketCapRank ?? -1) " + (tokenDescriptor?.symbol?.uppercased() ?? "")).fontTemplate(DefaultTemplate.subheadingRegular_secondary)
                }
                
                Spacer()
                VStack(alignment: .trailing, spacing: 5) {
                    if let change = tokenDetail?.priceChangePercentage24H {
                        ProminentRoundedLabel(text: (change >= 0 ? "+" : "") +
                                              "\("".forTrailingZero(temp: change.truncate(places: 2)))%",
                                              color: change >= 0 ? .green : .red,
                                              style: service.themeStyle)
                        
                        if let change = tokenDetail?.priceChange24H?.truncate(places: 2),
                           let isPositive = change >= 0 {
                            Text("\(isPositive ? "+" : "")\(Locale.current.currencySymbol ?? "")\(change.reduceScale(to: 2))")
                                .fontTemplate(FontTemplate(font: Font.system(size: 14.0), weight: .semibold, foregroundColor: isPositive ? .green : .red, lineSpacing: 0))
                        }
                    }
                }
            }
            
            HStack(alignment: .center, spacing: 0) {
                Text(Locale.current.currencySymbol ?? "").fontTemplate(DefaultTemplate.titleSemiBold)
                
                MovingNumbersView(number: tokenDetail?.currentPrice ?? 0.00,
                                  numberOfDecimalPlaces: tokenDetail?.currentPrice?.decimalCount() ?? 2 < 2 ? 2 : tokenDetail?.currentPrice?.decimalCount() ?? 2,
                                  fixedWidth: nil,
                                  animationDuration: 0.4,
                                  showComma: true) { str in
                    Text(str).fontTemplate(DefaultTemplate.titleSemiBold)
                }
                
                Spacer()
            }.mask(AppGradients.movingNumbersMask)
        }
        .padding(.horizontal)
    }
    
}
