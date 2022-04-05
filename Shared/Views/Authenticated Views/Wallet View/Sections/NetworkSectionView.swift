//
//  NetworkSectionView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 3/23/22.
//

import SwiftUI

struct NetworkSectionView: View {

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @EnvironmentObject private var walletRouter: WalletCoordinator.Router

    @ObservedObject private var service: AuthenticatedServices
    @ObservedObject private var store: WalletService

    init(service: AuthenticatedServices) {
        self.service = service
        self.store = service.wallet
    }

    var body: some View {
        LazyVStack(alignment: .center, spacing: 0) {
            SectionHeaderView(title: "Networks", action: {
                print("see more")
            })
            .padding(.vertical, 5)

            ScrollView(MobileConstants.deviceType == .phone ? .horizontal : .vertical, showsIndicators: false) {
                HStack(alignment: .center, spacing: 10) {
                    ForEach(store.completeBalance, id:\.self) { network in
    //                    NetworkCell(network: network, service: service)
                        NetworkVerticalCell(network: network, service: service, action: {
                            walletRouter.route(to: \.networkDetail, network)
                            #if os(iOS)
                                HapticFeedback.rigidHapticFeedback()
                            #endif
                        })
                        .frame(minWidth: 180, maxWidth: 200)
                        .frame(minHeight: 220, maxHeight: 260)
                        .padding(.leading, store.completeBalance.first == network ? 20 : 0)
                    }
                    .padding(.bottom, service.themeStyle == .shadow ? 20 : 0)
                }
            }
        }
//        .gridStyle(StaggeredGridStyle(MobileConstants.deviceType == .phone ? .horizontal : .vertical, tracks: MobileConstants.deviceType == .phone ? 1 : 2, spacing: 5))
    }

}