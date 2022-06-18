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
    private let balance: CompleteBalance
    private let network: String?

    @State private var showSheet = false
    @State var isHistoryLoading = false
    @State private var gridViews: [AnyView] = []

    init(data: CompleteBalance, network: String? = nil, service: AuthenticatedServices) {
        self.balance = data
        self.network = network
        self.service = service
        self.store = service.wallet
    }

    var body: some View {
        BackgroundColorView(style: service.themeStyle, {
            ScrollView(.vertical, showsIndicators: false) {
                StickyHeaderView(title: balance.network == "eth" ? "Ethereum" : balance.network == "bsc" ? "Binanace" : balance.network?.capitalized ?? "",
                                 subtitle: "subtitle of network view. will have to come back to this to fetch from backend.",
                                 style: service.themeStyle, localTitleImage: (balance.network == "bsc" ? "binance" : balance.network ?? "") + "_logo",
                                 localImage: "gradientBg3")

                Grid(gridViews.indices, id: \.self) { gridViews[$0] }
            }
        })
        .gridStyle(StaggeredGridStyle(.vertical, tracks: MobileConstants.deviceType == .phone ? 1 : 2, spacing: 0))
        .onAppear {
            DispatchQueue.main.async {
                Tool.hiddenTabBar()
            }

            self.gridViews = [
                AnyView(OverviewSectionView(completeBalance: balance, service: service)),
                AnyView(TokensSectionView(data: balance, service: service)),
                AnyView(HistorySectionView(isLoading: $isHistoryLoading, service: service, network: network))
            ]
        }
    }

    private var backButton : some View {
        BorderlessButton(title: "Back", systemImage: "chevron.left", size: .regular, action: {
            walletRouter.pop()
        })
    }

}
