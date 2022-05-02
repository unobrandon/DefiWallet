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
        TrendingView(service: services)
    }

    @ViewBuilder func makeCategories() -> some View {
        CategoriesView(service: services)
    }

    @ViewBuilder func makeMarketCapRank() -> some View {
        MarketCapRankView(service: services)
    }

    @ViewBuilder func makeTokenDetail(address: String) -> some View {
        TokenDetailView(address: address, service: services)
    }

}
