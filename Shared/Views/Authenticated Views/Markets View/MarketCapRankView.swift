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

    @State private var noMore: Bool = false
    @State var showIndicator: Bool = false
    @State private var page: Int = 1
    @State private var limitCells: Int = 10

    init(service: AuthenticatedServices) {
        self.service = service
        self.store = service.market
    }

    var body: some View {
        BackgroundColorView(style: service.themeStyle, {
            ScrollView {
                ListSection(title: "by top market cap", style: service.themeStyle) {
                    ForEach(store.coinsByMarketCap.prefix(limitCells), id: \.self) { item in
                        TokenListStandardCell(service: service, data: item,
                                              isLast: store.coinsByMarketCap.count < limitCells ? store.coinsByMarketCap.last == item ? true : false : false,
                                              style: service.themeStyle, action: {
                            walletRouter.route(to: \.detailsTokenDetail, item)

                            print("the item is: \(item)")
                        })
                    }
                }.padding(.top)

                RefreshFooter(refreshing: $showIndicator, action: {
                    guard limitCells > store.coinsByMarketCap.count else {
                        page += 1

                        DispatchQueue.main.async {
                            store.fetchCoinsByMarketCap(currency: service.currentUser.currency, page: page, completion: {
                                limitCells += 10
                                print("the count of each are: \(store.coinsByMarketCap.count) && \(limitCells)")

                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    withAnimation(.easeInOut) {
                                        showIndicator = false
                                    }
                                }
                            })
                        }

                        return
                    }

                    noMore = true
                    withAnimation(.easeInOut) {
                        showIndicator = false
                    }
                }, label: {
                    if noMore {
                        FooterInformation()
                    } else {
                        LoadingView(title: "loading tokens...")
                    }
                })
                .noMore(noMore)
                .preload(offset: 50)
            }.enableRefresh()
        })
        .navigationBarTitle("Market Cap", displayMode: .large)
        .onAppear {
            DispatchQueue.main.async {
                Tool.hiddenTabBar()
            }
        }
    }

}
