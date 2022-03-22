//
//  WalletCoordinator+Factory.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/13/22.
//

import SwiftUI
import Stinsen
import SafariServices

extension WalletCoordinator {

    @ViewBuilder func makeStart() -> some View {
        WalletView(service: services)
    }

    @ViewBuilder func makeHistory() -> some View {
        HistoryTransactionsView(service: services)
    }

    @ViewBuilder func makeHistoryDetail(data: HistoryData) -> some View {
        TransactionDetailView(data: data, service: services)
    }

    @ViewBuilder func makeSafari(url: URL) -> some View {
        SafariView(url: url)
    }

}
