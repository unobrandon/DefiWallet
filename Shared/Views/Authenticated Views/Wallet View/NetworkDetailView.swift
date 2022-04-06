//
//  NetworkDetailView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 4/5/22.
//

import SwiftUI

struct NetworkDetailView: View {

    @EnvironmentObject private var walletRouter: WalletCoordinator.Router

    @ObservedObject private var service: AuthenticatedServices
    @ObservedObject private var store: WalletService
    private let network: CompleteBalance

    @State private var headerOffsets: (CGFloat, CGFloat) = (0, 0)
    @State private var currentTab: String = "All"
    @State private var showSheet = false
    @State private var gridViews: [AnyView]

    init(data: CompleteBalance, network: Network? = nil, service: AuthenticatedServices) {
        self.network = data
        self.service = service
        self.store = service.wallet

        self.gridViews = [
            AnyView(OverviewSectionView(completeBalance: data, service: service)),
            AnyView(TokensSectionView(data: data, service: service)),
            AnyView(HistorySectionView(service: service, network: network))
        ]
    }

    var body: some View {
        BackgroundColorView(style: service.themeStyle, {
            ScrollView(.vertical, showsIndicators: false) {
                StickyHeaderView(title: network.network == "eth" ? "Ethereum" : network.network == "bsc" ? "Binanace" : network.network?.capitalized ?? "",
                                 subtitle: "subtitle of network view. will have to come back to this to fetch from backend.",
                                 style: service.themeStyle, localTitleImage: (network.network == "bsc" ? "binance" : network.network ?? "") + "_logo",
                                 localImage: "gradientBg3")

                Grid(gridViews.indices, id: \.self) { gridViews[$0] }
            }
        })
        .gridStyle(StaggeredGridStyle(.vertical, tracks: MobileConstants.deviceType == .phone ? 1 : 2, spacing: 0))
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
    }

    private var backButton : some View {
        BorderlessButton(title: "Back", systemImage: "chevron.left", size: .regular, action: {
            walletRouter.pop()
        })
    }

}
