//
//  TokenDetailOverviewSection.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 5/24/22.
//

import SwiftUI

struct TokenDetailOverviewSection: View {

    @ObservedObject private var service: AuthenticatedServices

    @State private var tokenDetail: TokenDetails?
    @State private var tokenDescriptor: TokenDescriptor?

    @State private var gridItems: [SwiftUI.GridItem] = {
        if MobileConstants.deviceType == .phone {
            return [SwiftUI.GridItem(.flexible()),
                    SwiftUI.GridItem(.flexible()),
                    SwiftUI.GridItem(.flexible())]
        } else {
            return [SwiftUI.GridItem(.flexible()),
                    SwiftUI.GridItem(.flexible()),
                    SwiftUI.GridItem(.flexible()),
                    SwiftUI.GridItem(.flexible()),
                    SwiftUI.GridItem(.flexible())]
        }
    }()

    init(tokenDetail: TokenDetails?, tokenDescriptor: TokenDescriptor?, service: AuthenticatedServices) {
        self.service = service
        self.tokenDetail = tokenDetail
        self.tokenDescriptor = tokenDescriptor
    }

    var body: some View {
        ListSection(title: "overview", hasPadding: true, style: service.themeStyle) {
            LazyVGrid(columns: gridItems, alignment: .center, spacing: 0) {
                if let marketRank = tokenDetail?.marketCapRank {
                    StackedStatisticLabel(title: "Market Rank", metric: "#\(marketRank)")
                }

                if let marketCap = tokenDetail?.marketCap,
                   let change = tokenDetail?.marketCapChangePercentage24H {
                    StackedStatisticLabel(title: "Market Cap", metric: nil, number: Double(marketCap), percent: "\(change)", percentColor: change >= 0 ? .green : .red, style: service.themeStyle)
                }

                if let totalVolume = tokenDetail?.totalVolume,
                    let marketCap = tokenDetail?.marketCap {
                    StackedStatisticLabel(title: "Volume / Market Cap", metric: "\(totalVolume / Double(marketCap))")
                }

                if let totalSupply = tokenDetail?.totalSupply {
                    StackedStatisticLabel(title: "Total Supply", metric: "\(totalSupply)")
                }

                if let circulatingSupply = tokenDetail?.circulatingSupply {
                    StackedStatisticLabel(title: "Circulating Supply", metric: "\(circulatingSupply)")
                }

                if let maxSupply = tokenDetail?.maxSupply {
                    StackedStatisticLabel(title: "Max Supply", metric: "\(maxSupply)")
                }

                if let ath = tokenDetail?.ath,
                   let athDate = tokenDetail?.athDate,
                   let change = tokenDetail?.athChangePercentage {
                    StackedStatisticLabel(title: "All Time High\n\(athDate.getFullElapsedInterval()) ago", number: ath, percent: "\(change)", percentColor: change >= 0 ? .green : .red, style: service.themeStyle)
                }

                if let atl = tokenDetail?.atl,
                   let atlDate = tokenDetail?.atlDate,
                   let change = tokenDetail?.atlChangePercentage {
                    StackedStatisticLabel(title: "All Time High\n\(atlDate.getFullElapsedInterval()) ago", number: atl, percent: "\(change)", percentColor: change >= 0 ? .green : .red, style: service.themeStyle)
                }
            }
        }
    }

}
