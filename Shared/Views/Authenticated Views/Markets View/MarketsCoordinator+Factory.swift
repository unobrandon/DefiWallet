//
//  MarketsCoordinator+Factory.swift
//  DefiWallet (iOS)
//
//  Created by Brandon Shaw on 2/14/22.
//

import SwiftUI
import Stinsen

extension MarketsCoordinator {

    func makeStart() -> some View {
        MarketsView(service: services)
    }

    func makeTrendingDetail() -> some View {
        TrendingView(service: services)
    }

    func makeCategories() -> some View {
        CategoriesView(service: services)
    }

    func makeMarketCapRank() -> some View {
        MarketCapRankView(service: services)
    }

}
