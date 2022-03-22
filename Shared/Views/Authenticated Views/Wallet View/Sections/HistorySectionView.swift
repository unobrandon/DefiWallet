//
//  HistorySectionView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 3/21/22.
//

import SwiftUI

struct HistorySectionView: View {

    @EnvironmentObject private var walletRouter: WalletCoordinator.Router

    @ObservedObject private var service: AuthenticatedServices
    @ObservedObject private var store: WalletService

    @State private var limitCells: Int = 5
    @State private var isLoading: Bool = true
    @State private var emptyTransactions: Bool = false

    init(service: AuthenticatedServices) {
        self.service = service
        self.store = service.wallet
    }

    var body: some View {
        LazyVStack(alignment: .center, spacing: 0) {
            SectionHeaderView(title: "History", actionTitle: store.history.isEmpty ? "" : store.history.count < limitCells ? "" : limitCells == 10 ? "Show less" : "Show more", action: showMoreLess)
            .padding(.vertical, 10)

            ListSection(style: service.themeStyle) {
                if store.history.isEmpty {
                    LoadingView(title: "loading past transactions...")
                } else if store.history.isEmpty, !store.isHistoryLoading {
                    HStack {
                        Spacer()
                        Text("empty transactions").fontTemplate(DefaultTemplate.caption)
                        Spacer()
                    }.padding(.vertical, 30)
                }

                ForEach(store.history.prefix(limitCells), id: \.self) { item in
                    HistoryListCell(service: service, data: item, isLast: store.history.count < limitCells ? store.history.last == item ? true : false : false, style: service.themeStyle, action: {
                        walletRouter.route(to: \.historyDetail, item)
                        #if os(iOS)
                            HapticFeedback.rigidHapticFeedback()
                        #endif
                    })

                    if store.history.last == item || item == store.history[limitCells - 1] {
                        ListStandardButton(title: "show \(store.history.count - limitCells) more...", systemImage: "ellipsis.circle", isLast: true, style: service.themeStyle, action: {
                            walletRouter.route(to: \.history)
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
