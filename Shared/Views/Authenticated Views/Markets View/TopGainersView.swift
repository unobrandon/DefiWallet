//
//  TopGainersView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 6/6/22.
//

import SwiftUI

struct TopGainersView: View {

    @EnvironmentObject private var walletRouter: MarketsCoordinator.Router

    @ObservedObject private var service: AuthenticatedServices
    @ObservedObject private var store: MarketsService

    @State private var noMore: Bool = false
    @State var showIndicator: Bool = false
    @State private var limitCells: Int = 25

    init(service: AuthenticatedServices) {
        self.service = service
        self.store = service.market

        store.coinsByGains.removeAll()
        self.fetchTopGainers()
    }

    var body: some View {
        BackgroundColorView(style: service.themeStyle, {
            ScrollView {
                VStack(alignment: .leading, spacing: 2.5) {
                    Text("A list of top gainers by 24 hour market cap percentage change.")
                        .fontTemplate(DefaultTemplate.bodySemibold)
                        .multilineTextAlignment(.leading)

                    ViewMoreText("This list sorts from the top 250 tokens ranked on top market caps to ensure the rankings are reasonable.")
                }
                .padding(.vertical, 10)
                .padding(.horizontal)

                ListSection(title: "By 24hr Market Cap Change", style: service.themeStyle) {
                    ForEach(store.coinsByGains.prefix(limitCells), id: \.self) { item in
                        TokenListStandardCell(service: service, data: item,
                                              isLast: store.coinsByGains.count < limitCells ? store.coinsByGains.last == item ? true : false : false,
                                              style: service.themeStyle, action: {
                            walletRouter.route(to: \.detailsTokenDetail, item)

                            print("the item is: \(item)")
                        })
                    }
                }.padding(.top)

                RefreshFooter(refreshing: $showIndicator, action: {
                    if limitCells <= store.coinsByGains.count {
                        limitCells += 25
                        withAnimation(.easeInOut) {
                            showIndicator = false
                            noMore = store.coinsByGains.count <= limitCells
                        }
                    }
                }, label: {
                    if noMore {
                        FooterInformation()
                    } else {
                        LoadingView(title: "loading...")
                    }
                })
                .noMore(noMore)
                .preload(offset: 50)
            }.enableRefresh()
        })
        .navigationBarTitle("Top Gainers", displayMode: .large)
        .onAppear {
            DispatchQueue.main.async {
                Tool.hiddenTabBar()
            }
        }
    }

    private func fetchTopGainers() {
        store.fetchTopGainers(currency: service.currentUser.currency, completion: {
            print("done fetching top gainers: \(store.exchanges.count) ** \(limitCells)")
            withAnimation(.easeInOut) {
                showIndicator = false
                noMore = store.exchanges.count < limitCells - 25
            }
        })
    }

}
