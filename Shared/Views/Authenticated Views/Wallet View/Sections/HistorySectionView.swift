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

    @Binding private var isLoading: Bool
    private let filter: Network?
    private var data: [TransactionResult] {
        var transactions: [TransactionResult] = []

        for network in self.store.completeBalance {
            guard let transact = network.transactions,
                  let result = transact.result else {
                return []
            }

            for item in result {
                transactions.append(item)
            }
        }

//        transactions.sorted(by: { $0.blockTimestamp ?? "" < $1.blockTimestamp ?? "" })

        return transactions
    }

    @State private var limitCells: Int = 5

    init(isLoading: Binding<Bool>, service: AuthenticatedServices, network: Network? = nil) {
        self._isLoading = isLoading
        self.service = service
        self.store = service.wallet
        self.filter = network
    }

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            SectionHeaderView(title: "History", actionTitle: store.history.isEmpty ? "" : "Show all", action: showMoreLess)
            .padding(.vertical, 5)

            ListSection(style: service.themeStyle) {
                if store.history.isEmpty, isLoading {
                    LoadingView(title: "")
                } else if store.history.isEmpty, !isLoading {
                    HStack {
                        Spacer()
                        Text("empty transactions").fontTemplate(DefaultTemplate.caption)
                        Spacer()
                    }.padding(.vertical, 30)
                }

                ForEach(data.prefix(limitCells), id: \.self) { item in
                    TransactionListCell(service: service, data: item, isLast: false, style: service.themeStyle, action: {
                        #if os(iOS)
                            HapticFeedback.rigidHapticFeedback()
                        #endif
                    })
//
//                    HistoryListCell(service: service, data: item, isLast: store.history.count < limitCells ? store.history.last == item ? true : false : false, style: service.themeStyle, action: {
//                        walletRouter.route(to: \.historyDetail, item)
//
//                        #if os(iOS)
//                            HapticFeedback.rigidHapticFeedback()
//                        #endif
//                    })

                    if item == data[limitCells - 1] {
                        ListStandardButton(title: "show \(data.count - limitCells) more...", systemImage: "ellipsis.circle", isLast: true, style: service.themeStyle, action: {
                            walletRouter.route(to: \.history, filter)

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
        walletRouter.route(to: \.history, filter)

        #if os(iOS)
            HapticFeedback.rigidHapticFeedback()
        #endif
    }

    private func filterHistory(_ filter: Network? = nil) -> [HistoryData] {
        if let filter = filter {
            return self.store.history.filter({ $0.network == filter })
        } else {
            return self.store.history
        }
    }

}
