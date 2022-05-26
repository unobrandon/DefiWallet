//
//  TokenDetailOverviewSection.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 5/24/22.
//

import SwiftUI

extension TokenDetailView {

    @ViewBuilder
        func detailsOverviewSection() -> some View {
            ListSection(title: "overview", hasPadding: true, style: service.themeStyle) {
            LazyVGrid(columns: gridItems, alignment: .center, spacing: 5) {
                if let totalVolume = tokenDetail?.totalVolume {
                    StackedStatisticLabel(title: "Total Volume", metric: "\(Locale.current.currencySymbol ?? "")\("".formatLargeNumber(Int(totalVolume), size: .regular).capitalized)", number: nil)
                } else {
                    StackedStatisticLabel(title: "Total Volume", metric: "?")
                }

                if let marketCap = tokenDetail?.marketCap,
                   let change = tokenDetail?.marketCapChangePercentage24H {
                    StackedStatisticLabel(title: "Market Cap", metric: "\(Locale.current.currencySymbol ?? "")\("".formatLargeNumber(marketCap, size: .regular).capitalized)", number: nil, percent: "\(change >= 0 ? "+" : "")\(change.reduceScale(to: 3))%", percentColor: change >= 0 ? .green : .red, style: service.themeStyle)
                }

                if let totalVolume = tokenDetail?.totalVolume,
                    let marketCap = tokenDetail?.marketCap {
                    StackedStatisticLabel(title: "Volume / \nMarket Cap", metric: "\(Double(totalVolume / Double(marketCap)).reduceScale(to: 4))%")
                } else {
                    StackedStatisticLabel(title: "Volume / \nMarket Cap", metric: "?")
                }

                if let fullyDilutedValuation = tokenDetail?.fullyDilutedValuation {
                    StackedStatisticLabel(title: "Fully Diluted \nValuation", metric: fullyDilutedValuation >= 999999999 ? "\(Locale.current.currencySymbol ?? "")" + "\("".formatLargeNumber(fullyDilutedValuation, size: .regular).capitalized)" : "\(Locale.current.currencySymbol ?? "")" + Double(fullyDilutedValuation).formatCommas())
                } else {
                    StackedStatisticLabel(title: "Fully Diluted \nValuation", metric: "?")
                }

                if let ath = tokenDetail?.ath,
                   let change = tokenDetail?.athChangePercentage {
                    StackedStatisticLabel(title: "All Time High", number: ath, percent: "\(change >= 0 ? "+" : "")\(change.reduceScale(to: 2))%", percentColor: change >= 0 ? .green : .red, style: service.themeStyle)
                } else {
                    StackedStatisticLabel(title: "All Time High", metric: "?")
                }

                if let atl = tokenDetail?.atl,
                   let change = tokenDetail?.atlChangePercentage {
                    StackedStatisticLabel(title: "All Time Low", number: atl, percent: "\(change >= 0 ? "+" : "")\("".formatLargeNumber(Int(change), size: .small))%", percentColor: change >= 0 ? .green : .red, style: service.themeStyle)
                } else {
                    StackedStatisticLabel(title: "All Time Low", metric: "?")
                }

                if let totalSupply = tokenDetail?.totalSupply {
                    StackedStatisticLabel(title: "Total Supply", metric: totalSupply >= 999999999 ? "\("".formatLargeNumber(Int(totalSupply), size: .large).capitalized)" : totalSupply.formatCommas())
                } else {
                    StackedStatisticLabel(title: "Total Supply", metric: "?")
                }

                if let circulatingSupply = tokenDetail?.circulatingSupply {
                    StackedStatisticLabel(title: "Circulating \nSupply", metric: circulatingSupply >= 999999999 ? "\("".formatLargeNumber(Int(circulatingSupply), size: .regular).capitalized)" : circulatingSupply.formatCommas())
                } else {
                    StackedStatisticLabel(title: "Circulating \nSupply", metric: "?")
                }

                if let maxSupply = tokenDetail?.maxSupply {
                    StackedStatisticLabel(title: "Max Supply", metric: maxSupply >= 999999999 ? "\("".formatLargeNumber(Int(maxSupply), size: .regular).capitalized)" : maxSupply.formatCommas())
                } else {
                    StackedStatisticLabel(title: "Max Supply", metric: "?")
                }
            }
        }
    }

}
