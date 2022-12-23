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

        self.store.exchanges.removeAll()
    }

    var body: some View {
        BackgroundColorView(style: service.themeStyle, {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 15) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("A digital currency exchange (DCE) is a platform that allows customers to trade cryptocurrencies for other assets, such as fiat currencies or other cryptocurrencies.")
                            .fontTemplate(DefaultTemplate.bodySemibold)
                            .multilineTextAlignment(.leading)

                        ViewMoreText("Exchanges provide a platform for the exchange of digital currencies and cryptocurrencies, accepting a range of payment methods such as credit card payments and wire transfers. \n\nThese exchanges can act as intermediaries, facilitating trades and earning a commission from the spread between bid and ask prices, or they may simply charge a fee for their services. \n\nWhile some brokerage firms, like Robinhood and eToro, allow users to purchase cryptocurrencies, they do not permit withdrawals to cryptocurrency wallets. Dedicated cryptocurrency exchanges, on the other hand, such as Binance and Coinbase, do offer the option to withdraw cryptocurrencies.")
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal)

                    ListSection(title: "By 24hr Trade Volume", hasPadding: false, style: service.themeStyle) {
                        ForEach(store.exchanges.prefix(limitCells), id: \.self) { exchange in
                            ExchangeCell(service: service,
                                         data: exchange,
                                         isLast: false,
                                         style: service.themeStyle, action: {
                                marketRouter.route(to: \.exchangeDetailView, exchange)
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
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Section {
                        Button {
                            store.exchanges.removeAll()
                            withAnimation(.easeInOut) { store.exchangesFilters = .name }
                            self.limitCells = 25
                            self.fetchExchanges()
                        } label: {
                            Label("Name", systemImage: store.exchangesFilters == .name ? "checkmark.circle.fill" : "circle")
                        }

                        Button {
                            store.exchanges.removeAll()
                            withAnimation(.easeInOut) { store.exchangesFilters = .oldest }
                            self.limitCells = 25
                            self.fetchExchanges()
                        } label: {
                            Label("Oldest", systemImage: store.exchangesFilters == .oldest ? "checkmark.circle.fill" : "circle")
                        }

                        Button {
                            store.exchanges.removeAll()
                            withAnimation(.easeInOut) { store.exchangesFilters = .gainers }
                            self.limitCells = 25
                            self.fetchExchanges()
                        } label: {
                            Label("24hr Gainers", systemImage: store.exchangesFilters == .gainers ? "checkmark.circle.fill" : "circle")
                        }

                        Button {
                            store.exchanges.removeAll()
                            withAnimation(.easeInOut) { store.exchangesFilters = .losers }
                            self.limitCells = 25
                            self.fetchExchanges()
                        } label: {
                            Label("24hr Losers", systemImage: store.exchangesFilters == .losers ? "checkmark.circle.fill" : "circle")
                        }
                    }
                } label: {
                    HStack {
                        Image(systemName: "list.bullet")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 18, height: 18, alignment: .center)
                        Text("Sort")
                    }
                }
                .buttonStyle(.borderless)
                .controlSize(.small)
                .buttonBorderShape(.roundedRectangle)
                .buttonStyle(ClickInteractiveStyle(0.99))
            }
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .automatic), prompt: "Search exchanges", suggestions: {
            Text("hello")
        })
        .onAppear {
            DispatchQueue.main.async {
                Tool.hiddenTabBar()
            }

            guard store.exchanges.isEmpty else { return }

            self.fetchExchanges()
        }
    }

    private func fetchExchanges() {
        showIndicator = true
        store.fetchTopExchanges(filter: store.exchangesFilters, pageSize: 25, skip: limitCells - 25, completion: {
            print("done fetching exchanges: \(store.exchanges.count) ** \(limitCells)")
            withAnimation(.easeInOut) {
                showIndicator = false
                noMore = store.exchanges.count < limitCells - 25
            }
        })
    }

}
