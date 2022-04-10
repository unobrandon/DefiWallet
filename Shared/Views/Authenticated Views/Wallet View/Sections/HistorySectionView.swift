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

    @State private var limitCells: Int = 5

    init(isLoading: Binding<Bool>, service: AuthenticatedServices, network: Network? = nil, filterString: String? = nil) {
        self._isLoading = isLoading
        self.service = service
        self.store = service.wallet
        self.filter = network
    }

    var body: some View {
        LazyVStack(alignment: .center, spacing: 0) {
            SectionHeaderView(title: "History", actionTitle: store.history.isEmpty ? "" : store.history.count < limitCells ? "" : limitCells == 10 ? "Show less" : "Show more", action: showMoreLess)
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

                ForEach(filterHistory(filter).prefix(limitCells), id: \.self) { item in
                    HistoryListCell(service: service, data: item, isLast: store.history.count < limitCells ? store.history.last == item ? true : false : false, style: service.themeStyle, action: {
                        walletRouter.route(to: \.historyDetail, item)
                        #if os(iOS)
                            HapticFeedback.rigidHapticFeedback()
                        #endif
                    })

                    if filterHistory(filter).last == item || item == filterHistory(filter)[limitCells - 1] {
                        ListStandardButton(title: "show \(filterHistory(filter).count - limitCells) more...", systemImage: "ellipsis.circle", isLast: true, style: service.themeStyle, action: {
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
