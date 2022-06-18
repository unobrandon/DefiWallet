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
    private var data: [NftResult] {
        var nfts: [NftResult] = []

        for network in self.store.completeBalance {
            guard let nft = network.nfts,
                  let result = nft.allNfts else {
                return []
            }

            for item in result {
                nfts.append(item)
            }
        }

        return nfts
    }

    @State private var limitCells: Int = MobileConstants.deviceType == .phone ? 9 : 12
    let gridItems: [SwiftUI.GridItem] = MobileConstants.deviceType == .phone ? [SwiftUI.GridItem(.flexible()), SwiftUI.GridItem(.flexible()), SwiftUI.GridItem(.flexible())] : [SwiftUI.GridItem(.flexible()), SwiftUI.GridItem(.flexible()), SwiftUI.GridItem(.flexible()), SwiftUI.GridItem(.flexible())]

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

            LazyVGrid(columns: gridItems, alignment: .center, spacing: 5) {
                ForEach(data.prefix(limitCells), id: \.self) { nftResult in
                    if nftResult == data.prefix(limitCells).last {
                        CollectableSeeAllCell(style: service.themeStyle, action: {
                            print("collectable see all tapped")
                        })
                    } else {
                        CollectableImageCell(service: service, data: nftResult, style: service.themeStyle, action: {
                            print("collectable tapped")
                        })
                    }
                }
            }
            .padding(.horizontal)
        }
    }

}
