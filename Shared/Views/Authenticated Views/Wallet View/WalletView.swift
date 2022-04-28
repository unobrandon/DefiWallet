//
//  WalletView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/13/22.
//

import SwiftUI
import Stinsen
import SwiftUICharts

struct WalletView: View {

    @EnvironmentObject private var walletRouter: WalletCoordinator.Router

    @ObservedObject private var service: AuthenticatedServices
    @ObservedObject private var store: WalletService

    @State private var showSheet = false
    @State var gridViews: [AnyView] = []

    @State var isBalanceLoading: Bool = false
    @State var isHistoryLoading: Bool = false
    let gridItems: [SwiftUI.GridItem] = MobileConstants.deviceType == .phone ? [SwiftUI.GridItem(.flexible())] : [SwiftUI.GridItem(.flexible()), SwiftUI.GridItem(.flexible())]

    init(service: AuthenticatedServices) {
        self.service = service
        self.store = service.wallet

        fetchNetworksBalances()
        fetchHistory()
    }

    var body: some View {
        BackgroundColorView(style: service.themeStyle, {
            ScrollView(.vertical, showsIndicators: false) {
                BalanceSectionView(service: service)

                LazyVGrid(columns: gridItems, alignment: .center, spacing: 0) {
                    NetworkSectionView(isLoading: self.$isBalanceLoading, service: service)
                    CollectablesSectionView(isLoading: self.$isBalanceLoading, service: service)
                    HistorySectionView(isLoading: self.$isHistoryLoading, service: service, network: nil)
                }
            }
        })
        .navigationBarTitle("", displayMode: .inline)
        .gridStyle(StaggeredGridStyle(.vertical, tracks: MobileConstants.deviceType == .phone ? 1 : 2, spacing: 0))
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                WalletNavigationView(service: service).offset(y: -2.5)
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                HStack(alignment: .center, spacing: 10) {
                    Button {
                        #if os(iOS)
                            HapticFeedback.rigidHapticFeedback()
                        #endif

                        SOCManager.present(isPresented: $showSheet) {
                            ScanQRView(showSheet: $showSheet, service: service)
                        }
                    } label: {
                        Image(systemName: "qrcode.viewfinder")
                    }
                    .foregroundColor(Color.primary)
                }
            }
        }
        .onAppear {
            DispatchQueue.main.async {
                Tool.showTabBar()
            }
        }
    }

    private func fetchNetworksBalances() {
        isBalanceLoading = true

        store.fetchAccountBalance(service.currentUser.address, completion: { completeBal in
            isBalanceLoading = false

            if let bal = completeBal {
                store.setAccountCollectables(bal, completion: { result in
                    DispatchQueue.main.async {
                        store.accountNfts = result
                        print("completed getting chain overview: \(store.accountBalance.count) && nfts: \(store.accountNfts.count)")
                    }
                })
            } else {
                print("failed getting complete balance")
            }
        })
    }

    private func fetchHistory() {
        isHistoryLoading = true

        store.fetchHistory(store.currentUser.wallet.address, completion: {
            isHistoryLoading = false
        })
    }

}
