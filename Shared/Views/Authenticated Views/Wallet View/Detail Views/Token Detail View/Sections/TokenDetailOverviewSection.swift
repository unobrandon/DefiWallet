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
                if let totalVolume = tokenModel?.totalVolume {
                    StackedStatisticLabel(title: "Total Volume", metric: "\(Locale.current.currencySymbol ?? "")\("".formatLargeNumber(Int(totalVolume), size: .regular).capitalized)", number: nil)
                } else {
                    StackedStatisticLabel(title: "Total Volume", metric: "?")
                }

//                if let marketCap = tokenModel?.marketCap,
//                   let change = tokenModel?.marketCapChangePercentage24H {
//                    StackedStatisticLabel(title: "Market Cap", metric: "\(Locale.current.currencySymbol ?? "")\("".formatLargeNumber(marketCap, size: .regular).capitalized)", number: nil, percent: "\(change >= 0 ? "+" : "")\(change.reduceScale(to: 3))%", percentColor: change >= 0 ? .green : .red, style: service.themeStyle)
//                }
//
//                if let totalVolume = tokenModel?.totalVolume,
//                    let marketCap = tokenModel?.marketCap {
//                    StackedStatisticLabel(title: "Volume / \nMarket Cap", metric: "\(Double(totalVolume / Double(marketCap)).reduceScale(to: 4))%")
//                } else {
//                    StackedStatisticLabel(title: "Volume / \nMarket Cap", metric: "?")
//                }

                if let fullyDilutedValuation = tokenModel?.fullyDilutedValuation {
                    StackedStatisticLabel(title: "Fully Diluted \nValuation", metric: fullyDilutedValuation >= 99999999 ? "\(Locale.current.currencySymbol ?? "")" + "\("".formatLargeNumber(fullyDilutedValuation, size: .regular).capitalized)" : "\(Locale.current.currencySymbol ?? "")" + Double(fullyDilutedValuation).formatCommas())
                } else {
                    StackedStatisticLabel(title: "Fully Diluted \nValuation", metric: "?")
                }

//                if let ath = tokenModel?.ath,
//                   let change = tokenModel?.athChangePercentage {
//                    StackedStatisticLabel(title: "All Time High", number: ath, percent: "\(change >= 0 ? "+" : "")\(change.reduceScale(to: 2))%", percentColor: change >= 0 ? .green : .red, style: service.themeStyle)
//                } else {
//                    StackedStatisticLabel(title: "All Time High", metric: "?")
//                }

                if let atl = tokenModel?.atl,
                   let change = tokenModel?.atlChangePercentage {
                    StackedStatisticLabel(title: "All Time Low", number: atl, percent: "\(change >= 0 ? "+" : "")\("".formatLargeNumber(Int(change), size: .small))%", percentColor: change >= 0 ? .green : .red, style: service.themeStyle)
                } else {
                    StackedStatisticLabel(title: "All Time Low", metric: "?")
                }

                if let totalSupply = tokenModel?.totalSupply {
                    StackedStatisticLabel(title: "Total Supply", metric: totalSupply >= 99999999 ? "\("".formatLargeNumber(Int(totalSupply), size: .regular).capitalized)" : totalSupply.formatCommas())
                } else {
                    StackedStatisticLabel(title: "Total Supply", metric: "?")
                }

                if let circulatingSupply = tokenModel?.circulatingSupply {
                    StackedStatisticLabel(title: "Circulating", metric: circulatingSupply >= 99999999 ? "\("".formatLargeNumber(Int(circulatingSupply), size: .regular).capitalized)" : circulatingSupply.formatCommas())
                } else {
                    StackedStatisticLabel(title: "Circulating", metric: "?")
                }

                if let maxSupply = tokenModel?.maxSupply {
                    StackedStatisticLabel(title: "Max Supply", metric: maxSupply >= 99999999 ? "\("".formatLargeNumber(Int(maxSupply), size: .regular).capitalized)" : maxSupply.formatCommas())
                } else {
                    StackedStatisticLabel(title: "Max Supply", metric: "?")
                }
            }
            .padding(5)
        }
    }

}
