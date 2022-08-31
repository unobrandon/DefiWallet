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
    private let filter: String?
    @State private var limitCells: Int = MobileConstants.deviceType == .phone ? 6 : 9
    private var data: [NftResult] {
        var nfts: [NftResult] = []

        guard let completeBalance = self.store.accountBalance?.completeBalance else { return [] }

        for network in completeBalance {
            guard let nft = network.nfts,
                  let result = nft.allNfts else {
                return []
            }

            for item in result {
                nfts.append(item)
            }
        }

        if self.filter != nil {
            nfts = nfts.filter({ $0.network == self.filter })
        }

        return nfts
    }

    init(isLoading: Binding<Bool>, network: String? = nil, service: AuthenticatedServices) {
        self._isLoading = isLoading
        self.filter = network
        self.service = service
        self.store = service.wallet
    }

    var body: some View {
        LazyVStack(alignment: .center, spacing: 0) {
            SectionHeaderView(title: "Collectables", actionTitle: store.history.isEmpty ? "" : "Show all", action: {
                seeAll()
            })
            .padding(.vertical, 5)

            if isLoading, store.accountBalance?.completeBalance != nil {
                LoadingView(title: "")
            }

            StaggeredGrid(columns: MobileConstants.deviceType == .phone ? 3 : 4, showsIndicators: false, spacing: 1, list: data, itemLimit: self.limitCells, content: { nftResult in
                if limitCells <= data.count, nftResult == data.prefix(limitCells).last {
                    CollectableSeeAllCell(style: service.themeStyle, action: {
                        seeAll()
                    })
                } else {
                    CollectableImageCell(service: service, data: nftResult, style: service.themeStyle, action: {
                        print("collectable tapped")
                    })
                }
            })
            .padding(.horizontal)

            if data.isEmpty {
                Text("empty collectables")
                    .fontTemplate(DefaultTemplate.caption)
                    .padding()
            }
        }
    }

    private func seeAll() {
        walletRouter.route(to: \.collectables, filter)

        #if os(iOS)
            HapticFeedback.rigidHapticFeedback()
        #endif
    }

}
