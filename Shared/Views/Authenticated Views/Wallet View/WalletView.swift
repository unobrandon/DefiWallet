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
    }

    var body: some View {
        BackgroundColorView(style: service.themeStyle, {
            ScrollView(.vertical, showsIndicators: false) {
                BalanceSectionView(service: service)

                LazyVGrid(columns: gridItems, alignment: .center, spacing: 0) {
                    NetworkSectionView(isLoading: self.$isBalanceLoading, service: service)
                    TokensSectionView(service: service)
                    CollectablesSectionView(isLoading: self.$isBalanceLoading, service: service)
                    HistorySectionView(isLoading: self.$isHistoryLoading, service: service, network: nil)
                }

                FooterInformation()
                    .padding(.vertical)
                    .padding(.bottom, 40)
            }
        })
        .navigationBarTitle("", displayMode: .inline)
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

            store.emitAccountRequest()
        }
        .onDisappear {
            store.stopAccountTimer()
        }
    }

    private func fetchNetworksBalances() {
        isBalanceLoading = true
        isHistoryLoading = true

        store.fetchAccountBalance(service.currentUser.address, service.currentUser.currency, completion: { _ in
            isBalanceLoading = false
            isHistoryLoading = false
        })
    }

}
