//
//  CollectablesSectionView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 4/10/22.
//

import SwiftUI

struct CollectablesSectionView: View {

    @EnvironmentObject private var walletRouter: WalletCoordinator.Router

    @ObservedObject private var service: AuthenticatedServices
    @ObservedObject private var store: WalletService

    @Binding private var isLoading: Bool
    private let filter: Network?

    @State private var limitCells: Int = 5

    init(isLoading: Binding<Bool>, service: AuthenticatedServices, network: Network? = nil) {
        self._isLoading = isLoading
        self.service = service
        self.store = service.wallet
        self.filter = network
    }

    var body: some View {
        LazyVStack(alignment: .center, spacing: 0) {
            SectionHeaderView(title: "Collectables", actionTitle: store.history.isEmpty ? "" : "Show all", action: {
                print("see more")
            })
            .padding(.vertical, 5)

            if isLoading, store.completeBalance.isEmpty {
                LoadingView(title: "")
            }

            Grid(store.accountNfts, id:\.self) { nftResult in
                CollectableCell(service: service, data: nftResult, style: service.themeStyle, action: {
                    print("collectable tapped")
                })
            }
            .padding(.horizontal)
        }
        .gridStyle(StaggeredGridStyle(.vertical, tracks: MobileConstants.deviceType == .phone ? 2 : 3, spacing: 5))
    }

}
