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

    @State var isBalanceLoading: Bool = true
    @State var isHistoryLoading: Bool = true
    let gridItems: [SwiftUI.GridItem] = MobileConstants.deviceType == .phone ? [SwiftUI.GridItem(.flexible())] : [SwiftUI.GridItem(.flexible()), SwiftUI.GridItem(.flexible())]
    @State var scrollOffset: CGFloat = CGFloat.zero
    @State var startSocketTimer: Timer?

    init(service: AuthenticatedServices) {
        self.service = service
        self.store = service.wallet

        fetchNetworksBalances()
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
                    TokensSectionView(isLoading: self.$isBalanceLoading, service: service)
                    CollectablesSectionView(isLoading: self.$isBalanceLoading, service: service)
                        .shadow(color: Color.black.opacity(service.themeStyle == .shadow ? 0.15 : 0.0), radius: 15, x: 0, y: 8)
                    HistorySectionView(isLoading: self.$isHistoryLoading, service: service, network: nil)
                }

                FooterInformation()
                    .padding(.top, 40)
                    .padding(.bottom)
            }.coordinateSpace(name: "wallet-scroll")
        })
        .navigationBarTitle("", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                WalletNavigationView(service: service, scrollOffset: $scrollOffset).offset(y: -2.5)
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

            self.startSocketTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                print("trying to get own tokens to start timer..")
                let tokenIds = store.getTokenIds()
                guard !tokenIds.isEmpty else { return }

                print("starting new wallet timer!!")
                self.service.socket.startWalletPriceTimer(tokenIds, currency: service.currentUser.currency)

                stopSocktStartTimer()
            }
        }
        .onDisappear {
            self.service.socket.stopWalletPriceTimer()
            isBalanceLoading = false
            isHistoryLoading = false
            stopSocktStartTimer()
        }
    }

    private func fetchNetworksBalances() {
//        guard !isBalanceLoading else { return }

        isBalanceLoading = false
        isHistoryLoading = false

        store.fetchAccountBalance(service.currentUser.address, service.currentUser.currency, completion: { _ in
            DispatchQueue.main.async {
                isBalanceLoading = false
                isHistoryLoading = false
            }

            store.gatherLocalAccountTokens(completion: { jsonString in
                guard let jsonString = jsonString else {
                    print("not valid json string produced...")
                    return
                }

                self.service.socket.emitPortfolioChartUpdate(currency: service.currentUser.currency, duration: store.chartType.getDaysFromChartType(), jsonData: jsonString)
            })
        })
    }

    private func stopSocktStartTimer() {
        guard let timer = startSocketTimer else { return }
        timer.invalidate()
        self.startSocketTimer = nil
    }

}
