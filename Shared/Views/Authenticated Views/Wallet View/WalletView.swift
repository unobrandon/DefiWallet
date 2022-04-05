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
    @State var gridViews: [AnyView]

    init(service: AuthenticatedServices) {
        self.service = service
        self.store = service.wallet
        self.gridViews = [
            AnyView(NetworkSectionView(service: service)),
            AnyView(HistorySectionView(service: service, network: nil))
        ]

        fetchNetworksBalances()
    }

    var body: some View {
        BackgroundColorView(style: service.themeStyle, {
            ScrollView(.vertical, showsIndicators: false) {
                BalanceSectionView(service: service)

                Grid(gridViews.indices, id:\.self) { index in
                    gridViews[index]
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
                        HapticFeedback.rigidHapticFeedback()
                        SOCManager.present(isPresented: $showSheet) {
                            ScanQRView(showSheet: $showSheet, service: service)
                            #if os(macOS)
                            .frame(height: 400, alignment: .center)
                            #elseif os(iOS)
                            .frame(minHeight: MobileConstants.screenHeight / 2.5, maxHeight: MobileConstants.screenHeight / 1.7, alignment: .center)
                            #endif
                        }
                    } label: {
                        Image(systemName: "qrcode.viewfinder")
                    }
                    .foregroundColor(Color.primary)
                }
            }
        }
    }

    private func fetchNetworksBalances() {
        store.fetchAccountBalance(service.currentUser.address, completion: {
            print("completed getting chain overview: \(store.accountBalance.count)")
        })
    }

}
