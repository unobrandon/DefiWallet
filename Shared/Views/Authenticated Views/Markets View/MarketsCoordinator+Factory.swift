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

    @ViewBuilder func makeCategoryDetail(category: TokenCategory) -> some View {
        CategoriesDetailView(category: category, service: services)
    }

    @ViewBuilder func makeMarketCapRank() -> some View {
        MarketCapRankView(service: services)
    }

    @ViewBuilder func makeTokenDetail(tokenDetail: TokenDetails) -> some View {
        TokenDetailView(tokenDetail: tokenDetail, tokenDescriptor: nil, externalId: nil, service: services)
    }

    @ViewBuilder func makeExternalTokenDetail(externalId: String) -> some View {
        TokenDetailView(tokenDetail: nil, tokenDescriptor: nil, externalId: externalId, service: services)
    }

    @ViewBuilder func makeDescriptorTokenDetail(tokenDescriptor: TokenDescriptor) -> some View {
        TokenDetailView(tokenDetail: nil, tokenDescriptor: tokenDescriptor, externalId: nil, service: services)
    }

}
