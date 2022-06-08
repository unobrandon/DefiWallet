//
//  TopCoinsSectionView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 3/24/22.
//

import SwiftUI

struct TopCoinsSectionView: View {

    @EnvironmentObject private var marketRouter: MarketsCoordinator.Router

    @ObservedObject private var service: AuthenticatedServices
    @ObservedObject private var store: MarketsService

    @State private var limitCells: Int = 10
    @Binding var isMarketCapLoading: Bool

    init(isLoading: Binding<Bool>, service: AuthenticatedServices) {
        self._isMarketCapLoading = isLoading
        self.service = service
        self.store = service.market

        fetchTopCoins()
    }

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            SectionHeaderView(title: "Market Cap",
                              actionTitle: store.coinsByMarketCap.isEmpty ? "" : "Show all",
                              action: showMoreLess)
            .padding(.bottom, 5)

            ListSection(style: service.themeStyle) {
                if store.coinsByMarketCap.isEmpty, isMarketCapLoading {
                    LoadingView(title: "")
                } else if store.coinsByMarketCap.isEmpty, !isMarketCapLoading {
                    HStack {
                        Spacer()
                        Text("error loading data").fontTemplate(DefaultTemplate.caption)
                        Spacer()
                    }.padding(.vertical, 30)
                }

                LazyVStack(alignment: .center, spacing: 0) {
                    ForEach(store.coinsByMarketCap.prefix(limitCells), id: \.self) { item in
                        TokenListStandardCell(service: service, data: item,
                                              isLast: store.coinsByMarketCap.count < limitCells ? store.coinsByMarketCap.last == item ? true : false : false,
                                              style: service.themeStyle, action: {
                            marketRouter.route(to: \.tokenDetail, item)

                            #if os(iOS)
                                HapticFeedback.rigidHapticFeedback()
                            #endif
                        })

                        if store.coinsByMarketCap.last == item || item == store.coinsByMarketCap[limitCells - 1] {
                            ListStandardButton(title: "view more...", systemImage: "ellipsis.circle", isLast: true, style: service.themeStyle, action: {
                                marketRouter.route(to: \.marketCapRank)

                                #if os(iOS)
                                    HapticFeedback.rigidHapticFeedback()
                                #endif
                            })
                        }
                    }
                }
            }
            .padding(.bottom)

            ListSection(title: "Other", hasPadding: true, style: service.themeStyle) {
                ListStandardButton(title: "Recently Added", systemImage: "safari", isLast: false, style: service.themeStyle, action: {
                    print("Recently Added")
                    marketRouter.route(to: \.recentlyAdded)
                })

                ListStandardButton(title: "Public Treasury", systemImage: "square.text.square", isLast: false, style: service.themeStyle, action: {
                    print("Public Market Treasury")
                    marketRouter.route(to: \.publicTreasury)
                })
            }

            FooterInformation()
                .padding(.vertical)
                .padding(.bottom, 40)
        }
    }

    private func showMoreLess() {
        marketRouter.route(to: \.marketCapRank)

        #if os(iOS)
            HapticFeedback.rigidHapticFeedback()
        #endif
    }

    private func fetchTopCoins() {
        store.fetchCoinsByMarketCap(currency: service.currentUser.currency, perPage: 25, page: 1, completion: {
            isMarketCapLoading = false
        })
    }

}
