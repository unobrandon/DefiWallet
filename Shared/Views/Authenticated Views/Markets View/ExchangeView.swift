//
//  ExchangesView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 5/25/22.
//

import SwiftUI

struct ExchangesView: View {

    @EnvironmentObject private var marketRouter: MarketsCoordinator.Router

    @ObservedObject private var service: AuthenticatedServices
    @ObservedObject private var store: MarketsService

    @State private var searchText: String = ""
    @State var showIndicator: Bool = false
    @State private var noMore: Bool = false
    @State private var limitCells: Int = 25

    init(service: AuthenticatedServices) {
        self.service = service
        self.store = service.market

        service.market.tokenCategories.removeAll()
        self.fetchExchanges()
    }

    var body: some View {
        BackgroundColorView(style: service.themeStyle, {
            ScrollView {
                LazyVStack(alignment: .leading) {
                    VStack(alignment: .leading, spacing: 2.5) {
                        Text("A digital currency exchange (DCE), allows customers to trade crypto for other assets, such as traditional fiat or other cryptocurrency's.")
                            .fontTemplate(DefaultTemplate.bodySemibold)
                            .multilineTextAlignment(.leading)

                        ViewMoreText("Exchanges may accept credit card payments, wire transfers or other forms of payment in exchange for digital currencies or cryptocurrencies. \n\nAn exchange can be a market maker that typically takes the bid–ask spreads as a transaction commission for is service or, as a matching platform, simply charges fees.\n\nSome brokerages which also focus on other assets such as stocks, like Robinhood and eToro, let users purchase but not withdraw cryptocurrencies to cryptocurrency wallets. Dedicated cryptocurrency exchanges such as Binance and Coinbase do allow cryptocurrency withdrawals, however.")
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal)

                    ListSection(title: "Top Exchanges", hasPadding: false, style: service.themeStyle) {
                        ForEach(store.exchanges.prefix(limitCells).indices, id: \.self) { index in
                            ExchangeCell(service: service,
                                         data: store.exchanges[index],
                                         index: index,
                                         isLast: false,
                                         style: service.themeStyle, action: {
                                marketRouter.route(to: \.exchangeDetailView, store.exchanges[index])

                                #if os(iOS)
                                    HapticFeedback.rigidHapticFeedback()
                                #endif
                            })
                        }
                    }
                    .padding(.horizontal)

                    RefreshFooter(refreshing: $showIndicator, action: {
                        limitCells += 25
                        fetchExchanges()
                    }, label: {
                        if noMore {
                            FooterInformation()
                        } else {
                            LoadingView()
                        }
                    })
                    .noMore(noMore)
                    .preload(offset: 50)
                }
            }.enableRefresh()
        })
        .navigationBarTitle("Exchanges", displayMode: .large)
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .automatic), prompt: "Search exchanges...", suggestions: {
            Text("hello")
        })
        .onAppear {
            DispatchQueue.main.async {
                Tool.hiddenTabBar()
            }
        }
    }

    private func fetchExchanges() {
        store.fetchTopExchanges(limit: limitCells, skip: limitCells - 25, completion: {
            print("done fetching exchanges: \(store.exchanges.count) ** \(limitCells)")
            withAnimation(.easeInOut) {
                showIndicator = false
                noMore = store.exchanges.count < limitCells - 25
            }
        })
    }

}
