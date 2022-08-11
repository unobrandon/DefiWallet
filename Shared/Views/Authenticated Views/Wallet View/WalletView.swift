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
    @State var walletPriceTimer: Timer?
    @State var scrollOffset: CGFloat = CGFloat.zero

    init(service: AuthenticatedServices) {
        self.service = service
        self.store = service.wallet
    }

    var body: some View {
        BackgroundColorView(style: service.themeStyle, {
            ScrollView(.vertical, showsIndicators: false) {
                BalanceSectionView(service: service)
                    .background(GeometryReader {
                        Color.clear.preference(key: ViewOffsetKey.self,
                            value: -$0.frame(in: .named("wallet-scroll")).origin.y)
                    })
                    .onPreferenceChange(ViewOffsetKey.self) {
                        self.scrollOffset = $0
                    }

                LazyVGrid(columns: gridItems, alignment: .center, spacing: 20) {
                    NetworkSectionView(isLoading: self.$isBalanceLoading, service: service)
                    TokensSectionView(service: service)
                    CollectablesSectionView(isLoading: self.$isBalanceLoading, service: service)
                    HistorySectionView(isLoading: self.$isHistoryLoading, service: service, network: nil)
                }

                FooterInformation()
                    .padding(.vertical)
                    .padding(.bottom, 40)
            }.coordinateSpace(name: "wallet-scroll")
        })
        .navigationBarTitle("", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                WalletNavigationView(service: service, scrollOffset: $scrollOffset, isLoading: $isBalanceLoading).offset(y: -2.5)
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

            fetchNetworksBalances()
            store.emitAccountRequest()
            startWalletPriceTimer()
        }
        .onDisappear {
            stopWalletPriceTimer()
            isBalanceLoading = false
            isHistoryLoading = false
        }
    }

    func fetchNetworksBalances() {
        guard !isBalanceLoading else { return }

        isBalanceLoading = true
        isHistoryLoading = true

        store.fetchAccountBalance(service.currentUser.address, service.currentUser.currency, completion: { _ in
            isBalanceLoading = false
            isHistoryLoading = false
        })
    }

    func startWalletPriceTimer() {
        self.walletPriceTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
            let tokenIds = store.getTokenIds()
            guard !tokenIds.isEmpty else { return }

            self.service.socket.emitPricesUpdate(tokenIds)
            print("emit Prices Update: \(tokenIds)")
        }
    }

    func stopWalletPriceTimer() {
        guard let timer = walletPriceTimer else { return }
        timer.invalidate()
        walletPriceTimer = nil
    }

}
