//
//  MarketsCoordinator+Factory.swift
//  DefiWallet (iOS)
//
//  Created by Brandon Shaw on 2/14/22.
//

import SwiftUI
import Stinsen

extension MarketsCoordinator {

    @ViewBuilder func makeStart() -> some View {
        MarketsView(service: services)
    }

    @ViewBuilder func makeTrendingDetail() -> some View {
        TrendingDetailView(service: services)
    }

    @ViewBuilder func makeMarketCapRank() -> some View {
        MarketCapRankView(service: services)
    }

}
