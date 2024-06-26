//
//  NetworkSectionView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 3/23/22.
//

import SwiftUI

struct NetworkSectionView: View {

    @EnvironmentObject private var walletRouter: WalletCoordinator.Router

    @ObservedObject private var service: AuthenticatedServices
    @ObservedObject private var store: WalletService

    @Binding private var isLoading: Bool

    init(isLoading: Binding<Bool>, service: AuthenticatedServices) {
        self._isLoading = isLoading
        self.service = service
        self.store = service.wallet
    }

    var body: some View {
        LazyVStack(alignment: .center, spacing: 0) {
            SectionHeaderView(title: "Networks", action: {
                print("see more")
            })
            .padding(.bottom, 5)

            if isLoading, store.accountBalance?.completeBalance == nil {
                LoadingView(title: "")
            }

            ScrollView(MobileConstants.deviceType == .phone ? .horizontal : .vertical, showsIndicators: false) {
                HStack(alignment: .center, spacing: 10) {
                    ForEach(store.accountBalance?.completeBalance ?? [], id:\.self) { network in
    //                    NetworkCell(network: network, service: service)
                        NetworkVerticalCell(network: network, service: service, action: {
                            walletRouter.route(to: \.networkDetail, network)
                        })
                        .frame(width: 140)
                    }
                }.padding(.horizontal)
            }
        }
        .shadow(color: Color.black.opacity(service.themeStyle == .shadow ? 0.15 : 0.0), radius: 15, x: 0, y: 8)
    }

}
