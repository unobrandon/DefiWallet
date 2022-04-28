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

    @ViewBuilder func makeSendTo() -> some View {
        SendToView(service: services)
    }

    @ViewBuilder func makeSendToDetail(address: String) -> some View {
        SendToDetailView(address: address, service: services)
    }

    @ViewBuilder func makeNetworkDetail(data: CompleteBalance) -> some View {
        NetworkDetailView(data: data, network: formateNetwork(data.network), service: services)
    }

    private func formateNetwork(_ txt: String? = nil) -> Network? {
        if txt == "eth" { return .ethereum
        } else if txt == "polygon" { return .polygon
        } else if txt == "bsc" { return .binanceSmartChain
        } else if txt == "avalanche" { return .avalanche
        } else if txt == "fantom" { return .fantom
        } else { return nil }
    }

    @ViewBuilder func makeHistory(network: Network? = nil) -> some View {
        HistoryTransactionsView(filtered: network, service: services)
    }

    @ViewBuilder func makeHistoryDetail(data: HistoryData) -> some View {
        TransactionDetailView(data: data, service: services)
    }

    @ViewBuilder func makeSafari(url: URL) -> some View {
        SafariView(url: url)
    }

}
