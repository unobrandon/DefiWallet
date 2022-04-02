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

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center, spacing: 0) {
                    ForEach(store.completeBalance, id:\.self) { network in
    //                    NetworkCell(network: network, service: service)
                        NetworkVerticalCell(network: network, service: service, action: {
                            
                        })
                        .frame(minWidth: 220, maxWidth: 280)
                        .padding(.leading, store.completeBalance.first == network ? 20 : 0)
                    }
                }
                .padding(.bottom, service.themeStyle == .shadow ? 20 : 0)
            }
        }
//        .gridStyle(StaggeredGridStyle(.vertical, tracks: 2, spacing: 0))
    }
}
