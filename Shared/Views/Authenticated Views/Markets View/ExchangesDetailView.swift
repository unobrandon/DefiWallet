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
                HStack {
                    VStack(alignment: .leading, spacing: 2.5) {
                        Text("The \(exchange.name ?? "") market cap is 24 hour volume.")
                            .fontTemplate(DefaultTemplate.bodySemibold)
                            .multilineTextAlignment(.leading)
                            .padding(.bottom, exchange.exchangeModelDescription ?? "" != "" ? 0 : 20)

                        if let description = exchange.exchangeModelDescription, !description.isEmpty {
                            ViewMoreText(description)
                        }
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)

                ListSection(title: "exchange tickers", style: service.themeStyle) {
                    ForEach(store.tokenCategoryList.prefix(limitCells).indices, id: \.self) { index in
                        TokenListStandardCell(service: service, data: store.tokenCategoryList[index],
                                              isLast: false,
                                              style: service.themeStyle, action: {
                            marketRouter.route(to: \.tokenDetail, store.tokenCategoryList[index])

                            print("the item is: \(store.tokenCategoryList[index].name ?? "no name")")

                            #if os(iOS)
                                HapticFeedback.rigidHapticFeedback()
                            #endif
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
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .automatic), prompt: "Search tickers...")
        .onAppear {
            DispatchQueue.main.async {
                Tool.hiddenTabBar()
            }

            guard let id = exchange.externalID else { return }
//            service.market.fetchCategoryDetails(categoryId: id, currency: service.currentUser.currency)
        }
    }

}
