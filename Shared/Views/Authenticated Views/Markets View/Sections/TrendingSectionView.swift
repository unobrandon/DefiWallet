//
//  TrendingSectionView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 4/2/22.
//

import SwiftUI

struct TrendingSectionView: View {

    @EnvironmentObject private var marketRouter: MarketsCoordinator.Router

    @ObservedObject private var service: AuthenticatedServices
    @ObservedObject private var store: MarketsService

    @State private var limitCells: Int = 4

    init(service: AuthenticatedServices) {
        self.service = service
        self.store = service.market
    }

    var body: some View {
        ListSection(style: service.themeStyle) {
            Button(action: {
                self.actionTap()
            }, label: {
                VStack(alignment: .center, spacing: 0) {
                    ListTitleView(title: "🔥 Trending", actionText: "See all", style: service.themeStyle)

                    if store.isTrendingLoading {
                        LoadingView(title: "")
                    } else if store.trendingCoins.isEmpty, !store.isTrendingLoading {
                        HStack {
                            Spacer()
                            Text("error loading trending").fontTemplate(DefaultTemplate.caption)
                            Spacer()
                        }.padding(.vertical, 30)
                    }

                    LazyVStack(alignment: .center, spacing: 0) {
                        ForEach(store.trendingCoins.prefix(limitCells), id: \.self) { item in
                            if let item = item.item {
                                TrendingTokenListCell(service: service, data: item, style: service.themeStyle)
                            }
                        }
                    }
                    .padding(.vertical, 7.5)
                }
            })
            .buttonStyle(DefaultInteractiveStyle(style: service.themeStyle))
            .frame(minWidth: 100, maxWidth: .infinity)
        }
    }

    private func actionTap() {
        guard !store.trendingCoins.isEmpty else { return }

        #if os(iOS)
            HapticFeedback.lightHapticFeedback()
        #endif

       marketRouter.route(to: \.trendingDetail)
    }

}
