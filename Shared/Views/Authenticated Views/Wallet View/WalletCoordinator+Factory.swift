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

    @ViewBuilder func makeHistory(network: Network? = nil) -> some View {
        HistoryView(filtered: network, service: services)
    }

    @ViewBuilder func makeHistoryDetail(data: HistoryData) -> some View {
        HistoryDetailView(data: data, service: services)
    }

    @ViewBuilder func makeTokenDetail(tokenDetail: TokenDetails) -> some View {
        TokenDetailView(tokenDetail: tokenDetail, tokenDescriptor: nil, externalId: nil, service: services)
    }

    @ViewBuilder func makeExternalTokenDetail(externalId: String) -> some View {
        TokenDetailView(tokenDetail: nil, tokenDescriptor: nil, externalId: externalId, service: services)
    }

    @ViewBuilder func makeDescriptorTokenDetail(tokenDescriptor: TokenDescriptor) -> some View {
        TokenDetailView(tokenDetail: nil, tokenDescriptor: tokenDescriptor, externalId: nil, service: services)
    }

    @ViewBuilder func makeSafari(url: URL) -> some View {
        SafariView(url: url)
    }

    private func formateNetwork(_ txt: String? = nil) -> Network? {
        if txt == "eth" { return .ethereum
        } else if txt == "polygon" { return .polygon
        } else if txt == "bsc" { return .binanceSmartChain
        } else if txt == "avalanche" { return .avalanche
        } else if txt == "fantom" { return .fantom
        } else { return nil }
    }

}
