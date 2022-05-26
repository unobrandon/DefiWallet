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
                    Text("Digital currency exchange (DCE), is a business that allows customers to trade crypto for other assets, such as conventional fiat money or other digital currencies. An exchange can be a market maker that typically takes the bid–ask spreads as a transaction commission for is service or, as a matching platform, simply charges fees.")
                        .fontTemplate(DefaultTemplate.bodySemibold)
                        .multilineTextAlignment(.leading)
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
                noMore = store.tokenCategories.count < limitCells
            }
        })
    }

}
