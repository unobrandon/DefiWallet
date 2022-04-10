//
//  MarketCapRankView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 4/3/22.
//

import SwiftUI

struct MarketCapRankView: View {

    @EnvironmentObject private var walletRouter: MarketsCoordinator.Router

    @ObservedObject private var service: AuthenticatedServices
    @ObservedObject private var store: MarketsService

    @State var enableLoadMore: Bool = true
    @State var showIndicator: Bool = false
    @State private var page: Int = 1
    @State private var limitCells: Int = 25

    init(service: AuthenticatedServices) {
        self.service = service
        self.store = service.market
    }

    var body: some View {
        BackgroundColorView(style: service.themeStyle, {
            LoadMoreScrollView(enableLoadMore: $enableLoadMore, showIndicator: $showIndicator, onLoadMore: {
                guard limitCells <= store.coinsByMarketCap.count else {
                    enableLoadMore = false
                    showIndicator = true
                    page += 1

                    store.fetchCoinsByMarketCap(currency: service.currentUser.currency, page: page, completion: {
                        showIndicator = false

                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            enableLoadMore = true
                        }
                    })

                    return
                }

                limitCells += 25
                showIndicator = false
                enableLoadMore = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    enableLoadMore = true
                    showIndicator = false
                }
            }, {
                ListSection(style: service.themeStyle) {
                    ForEach(store.coinsByMarketCap.prefix(limitCells), id: \.self) { item in
                        TokenListStandardCell(service: service, data: item,
                                              isLast: store.coinsByMarketCap.count < limitCells ? store.coinsByMarketCap.last == item ? true : false : false,
                                              style: service.themeStyle, action: {
    //                        walletRouter.route(to: \.historyDetail, item)

                            #if os(iOS)
                                HapticFeedback.rigidHapticFeedback()
                            #endif
                        })
                    }
                }
            })
            .padding(.vertical)
        })
        .navigationBarTitle("Market Cap", displayMode: .inline)
    }

}
