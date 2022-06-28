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
    @State private var limitCells: Int = 25

    init(service: AuthenticatedServices) {
        self.service = service
        self.store = service.market
    }

    var body: some View {
        BackgroundColorView(style: service.themeStyle, {
            ScrollView {
                ListSection(style: service.themeStyle) {
                    ForEach(store.coinsByMarketCap.prefix(limitCells), id: \.self) { item in
                        TokenListStandardCell(service: service, data: item,
                                              isLast: store.coinsByMarketCap.count < limitCells ? store.coinsByMarketCap.last == item ? true : false : false,
                                              style: service.themeStyle, action: {
//                            walletRouter.route(to: \.tokenDetail, item)

                            print("the item is: \(item)")
                        })
                    }
                }.padding(.top)

                RefreshFooter(refreshing: $showIndicator, action: {
                    guard limitCells <= store.coinsByMarketCap.count else {
                        page += 1

                        DispatchQueue.main.async {
                            store.fetchCoinsByMarketCap(currency: service.currentUser.currency, page: page, completion: {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    limitCells += 25
                                    withAnimation(.easeInOut) {
                                        showIndicator = false
                                        noMore = store.coinsByMarketCap.count <= limitCells
                                    }
                                }
                            })
                        }

                        return
                    }

                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        limitCells += 25
                        withAnimation(.easeInOut) {
                            showIndicator = false
                        }
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
