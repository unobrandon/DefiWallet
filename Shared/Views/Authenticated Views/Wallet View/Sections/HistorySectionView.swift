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
    private let filter: String?
    private var data: [TransactionResult] {
        var transactions: [TransactionResult] = []

        guard let completeBalance = self.store.accountBalance?.completeBalance else { return [] }

        for network in completeBalance {
            guard let transact = network.transactions,
                  let result = transact.result else {
                return []
            }

            for item in result {
                transactions.append(item)
            }
        }

//        transactions.sorted(by: { $0.blockTimestamp ?? 0 < $1.blockTimestamp ?? 0 })

        return transactions
    }

    @State private var limitCells: Int = 5

    init(isLoading: Binding<Bool>, service: AuthenticatedServices, network: String? = "") {
        self._isLoading = isLoading
        self.service = service
        self.store = service.wallet
        self.filter = network
    }

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            SectionHeaderView(title: "Transactions", actionTitle: data.isEmpty ? "" : "Show all", action: showMoreLess)
            .padding(.vertical, 5)

            ListSection(style: service.themeStyle) {
                if data.isEmpty, isLoading {
                    LoadingView(title: "")
                } else if data.isEmpty, !isLoading {
                    HStack {
                        Spacer()
                        Text("empty transactions").fontTemplate(DefaultTemplate.caption)
                        Spacer()
                    }.padding(.vertical, 30)
                }

                let transactionData = data.sorted(by: { $0.blockTimestamp ?? 0 > $1.blockTimestamp ?? 0 })
                ForEach(transactionData.prefix(limitCells), id: \.self) { item in
                    TransactionListCell(service: service, data: item, isLast: false, style: service.themeStyle, action: {
                        walletRouter.route(to: \.historyDetail, item)

                    })

                    if item == transactionData.prefix(limitCells).last {
                        ListStandardButton(title: "show all...", systemImage: "ellipsis.circle", isLast: true, style: service.themeStyle, action: {
                            walletRouter.route(to: \.history, filter)
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

}
