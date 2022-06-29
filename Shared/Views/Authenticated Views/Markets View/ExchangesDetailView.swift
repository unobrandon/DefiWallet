//
//  ExchangesDetailView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 5/25/22.
//

import SwiftUI

struct ExchangesDetailView: View {

    @EnvironmentObject private var marketRouter: MarketsCoordinator.Router

    @ObservedObject private var service: AuthenticatedServices
    @ObservedObject private var store: MarketsService
    let exchange: ExchangeModel

    @State private var searchText: String = ""
    @State private var noMore: Bool = false
    @State var showIndicator: Bool = false
    @State private var limitCells: Int = 25

    init(exchange: ExchangeModel, service: AuthenticatedServices) {
        self.exchange = exchange
        self.service = service
        self.store = service.market

        self.store.tokenCategoryList.removeAll()
    }

    var body: some View {
        BackgroundColorView(style: service.themeStyle, {
            ScrollView {

                CustomLineChart(data: store.exchangeDetails?.chartValue ?? [], profit: true)
                    .frame(height: 120)
                    .padding()

                HStack {
                    VStack(alignment: .leading, spacing: 2.5) {
                        Text("The \(exchange.name ?? "") 24 hour trade volume is \("".formatLargeDoubleNumber(exchange.tradeVolume24HBtc ?? 0.00, size: .large, scale: 3)) BTC.")
                            .fontTemplate(DefaultTemplate.bodySemibold)
                            .multilineTextAlignment(.leading)
                            .padding(.bottom, exchange.exchangeModelDescription ?? "" != "" ? 0 : 20)

                        if let description = exchange.exchangeModelDescription, !description.isEmpty {
                            ViewMoreText(description)
                        }

                        if let videoId = exchange.ytVideoId, !videoId.isEmpty {
                            YTVideoView(videoId: videoId).frame(width: 160, height: 150, alignment: .center)
                        }
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)

                ListSection(title: "exchange tickers", style: service.themeStyle) {
                    ForEach(store.exchangeDetails?.tickers?.prefix(limitCells) ?? [], id: \.self) { ticker in
                        ExchangePairCell(service: service, data: ticker, isLast: false, style: service.themeStyle, action: {
                            guard let urlString = ticker.tradeURL, let url = URL(string: urlString) else { return }

                            marketRouter.route(to: \.tickerSafariView, url)
                        })
                    }
                }

                RefreshFooter(refreshing: $showIndicator, action: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        limitCells += 25
                        withAnimation(.easeInOut) {
                            showIndicator = false
                            noMore = store.tokenCategories.count <= limitCells
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
        .navigationBarTitle(exchange.name ?? "Exchange Tickers", displayMode: .large)
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .automatic), prompt: "Search tickers")
        .onAppear {
            DispatchQueue.main.async {
                Tool.hiddenTabBar()
            }

            guard let id = exchange.externalID else { return }
//            service.market.fetchCategoryDetails(categoryId: id, currency: service.currentUser.currency)
            store.fetchExchangeDetails(id, chartDays: 7, page: 1)
        }
    }

}
