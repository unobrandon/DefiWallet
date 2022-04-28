//
//  TrendingDetailsView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 4/3/22.
//

import SwiftUI

struct TrendingView: View {

    @EnvironmentObject private var marketRouter: MarketsCoordinator.Router

    @ObservedObject private var service: AuthenticatedServices
    @ObservedObject private var store: MarketsService

    init(service: AuthenticatedServices) {
        self.service = service
        self.store = service.market
    }

    var body: some View {
        BackgroundColorView(style: service.themeStyle, {
            ScrollView(showsIndicators: true) {
                ListSection(style: service.themeStyle) {
                    ForEach(store.trendingCoins, id: \.self) { item in
                        if let item = item.item {
                            TrendingTokenStandardCell(service: service, data: item, isLast: store.trendingCoins.last?.item == item ? true : false, style: service.themeStyle, action: {
//                                marketRouter.route(to: \.historyDetail, item)
                                print("open \(item.name ?? "")")
                                #if os(iOS)
                                    HapticFeedback.rigidHapticFeedback()
                                #endif
                            })
                        }
                    }
                }
            }
            .padding(.vertical)
        })
        .navigationBarTitle("🔥 Trending", displayMode: .inline)
        .onAppear {
            DispatchQueue.main.async {
                Tool.hiddenTabBar()
            }
        }
    }

}
