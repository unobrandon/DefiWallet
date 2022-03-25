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

    @State private var limitCells: Int = 5
    @State private var isLoading: Bool = true
    @State private var emptyTransactions: Bool = false

    init(service: AuthenticatedServices) {
        self.service = service
        self.store = service.market
    }

    var body: some View {
        LazyVStack(alignment: .center, spacing: 0) {
            SectionHeaderView(title: "Market Cap",
                              actionTitle: store.coinsByMarketCap.isEmpty ? "" : store.coinsByMarketCap.count < limitCells ? "" : limitCells == 10 ? "Show less" : "Show more",
                              action: showMoreLess)
            .padding(.vertical, 10)

            ListSection(style: service.themeStyle) {
                if store.coinsByMarketCap.isEmpty {
                    LoadingView(title: "")
                } else if store.coinsByMarketCap.isEmpty, !store.isMarketCapLoading {
                    HStack {
                        Spacer()
                        Text("error loading data").fontTemplate(DefaultTemplate.caption)
                        Spacer()
                    }.padding(.vertical, 30)
                }

                ForEach(store.coinsByMarketCap.prefix(limitCells), id: \.self) { item in
                    TokenListStandardCell(service: service, data: item,
                                          isLast: store.coinsByMarketCap.count < limitCells ? store.coinsByMarketCap.last == item ? true : false : false,
                                          style: service.themeStyle, action: {
//                        walletRouter.route(to: \.historyDetail, item)

                        #if os(iOS)
                            HapticFeedback.rigidHapticFeedback()
                        #endif
                    })

                    if store.coinsByMarketCap.last == item || item == store.coinsByMarketCap[limitCells - 1] {
                        ListStandardButton(title: "view more...", systemImage: "ellipsis.circle", isLast: true, style: service.themeStyle, action: {
//                            walletRouter.route(to: \.history)

                            #if os(iOS)
                                HapticFeedback.rigidHapticFeedback()
                            #endif
                        })
                    }
                }
            }
        }
    }

    private func showMoreLess() {
        if limitCells == 5 {
            withAnimation(.easeOut) { limitCells += 5 }
        } else if limitCells == 10 {
            withAnimation(.easeOut) { limitCells -= 5 }
        }
    }

}
