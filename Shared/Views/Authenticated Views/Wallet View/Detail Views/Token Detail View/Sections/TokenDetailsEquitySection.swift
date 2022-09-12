//
//  TokenDetailsEquitySection.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 9/11/22.
//

import SwiftUI

extension TokenDetailView {

    @ViewBuilder
    func detailsEquitySection() -> some View {
        ListSection(title: "Your Portfolio", hasPadding: true, style: service.themeStyle) {
            LazyVGrid(columns: gridItems, alignment: .center, spacing: 5) {
                if let native = tokenModel?.nativeBalance,
                   let roundedValue = native.truncate(places: 3) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Amount").fontTemplate(FontTemplate(font: Font.system(size: 12.0), weight: .regular, foregroundColor: .secondary, lineSpacing: 1))

                        HStack(alignment: .center, spacing: 4) {
                            Text("".forTrailingZero(temp: roundedValue))
                                .fontTemplate(DefaultTemplate.metricFont)

                            Text(tokenModel?.symbol?.uppercased() ?? "")
                                .fontTemplate(DefaultTemplate.caption)
                                .adjustsFontSizeToFitWidth(true)
                                .minimumScaleFactor(0.7)
                                .lineLimit(1)
                        }
                    }.offset(y: -5)
                } else {
                    StackedStatisticLabel(title: "Amount", metric: "0.00", number: nil)
                }

                HStack {
                    Divider()
                    Spacer()
                    StackedStatisticLabel(title: "Value", number: tokenModel?.totalBalance ?? 0.00)
                    Spacer()
                    Divider()
                }

                StackedStatisticLabel(title: "Diversity", metric: "\(tokenModel?.portfolioDiversity ?? "0.00%")", number: nil)
            }
            .padding(.horizontal, 15)
            .padding(.top)
            .padding(.bottom, 10)
        }
    }

}
