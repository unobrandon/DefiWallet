//
//  TopGainersView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 6/6/22.
//

import SwiftUI

struct TopGainersLosersView: View {

    @EnvironmentObject private var walletRouter: MarketsCoordinator.Router

    @ObservedObject private var service: AuthenticatedServices
    @ObservedObject private var store: MarketsService

    @State private var noMore: Bool = false
    @State var showIndicator: Bool = false
    @State private var limitCells: Int = 25
	
	private var page: Int = 1
	private var gainOrLoss: String

	init(service: AuthenticatedServices, gainOrLoss: String) {
        self.service = service
        self.store = service.market
		self.gainOrLoss = gainOrLoss

        store.coinsByGainsLosers.removeAll()
		self.fetchTopGainersLosers(gainOrLoss: gainOrLoss, page: self.page)
    }

    var body: some View {
        BackgroundColorView(style: service.themeStyle, {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
					Text("A list of top \(self.gainOrLoss) by 24 hour market cap percentage change.")
                        .fontTemplate(DefaultTemplate.bodySemibold)
                        .multilineTextAlignment(.leading)

                    Text("This list sorts from the top 250 tokens ranked on top market caps to ensure the rankings are reasonable.")
                        .fontTemplate(DefaultTemplate.caption)
                        .multilineTextAlignment(.leading)
                }
                .padding(.vertical, 10)
                .padding(.horizontal)

                ListSection(title: "By 24hr Market Cap Change", style: service.themeStyle) {
                    ForEach(store.coinsByGainsLosers.prefix(limitCells), id: \.self) { item in
                        TokenListStandardCell(service: service, data: item,
                                              isLast: store.coinsByGainsLosers.count < limitCells ? store.coinsByGainsLosers.last == item ? true : false : false,
                                              style: service.themeStyle, action: {
                            walletRouter.route(to: \.detailsTokenDetail, item)

                            print("the item is: \(item)")
                        })
                    }
                }.padding(.top)

                RefreshFooter(refreshing: $showIndicator, action: {
                    if limitCells <= store.coinsByGainsLosers.count {
                        limitCells += 25
                        withAnimation(.easeInOut) {
                            showIndicator = false
                            noMore = store.coinsByGainsLosers.count <= limitCells
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

	private func fetchTopGainersLosers(gainOrLoss: String, page: Int) {
        showIndicator = true

		store.fetchTopCoins(currency: service.currentUser.currency, gainOrLoss: gainOrLoss, page: page.description, completion: {
            print("done fetching top \(gainOrLoss): \(store.coinsByGainsLosers.count) ** \(limitCells) 4 page: \(page)")
            withAnimation(.easeInOut) {
                showIndicator = false
                noMore = store.coinsByGainsLosers.count < limitCells - 25
            }
        })
    }

}
