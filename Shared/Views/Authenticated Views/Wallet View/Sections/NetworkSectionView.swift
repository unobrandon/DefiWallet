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
            .padding(.vertical, 10)

            VStack(alignment: .center, spacing: 0) {
                ForEach(store.completeBalance, id:\.self) { balance in
                    NetworkCell(network: balance, service: service)
                }
            }
        }
//        .gridStyle(StaggeredGridStyle(.vertical, tracks: 1, spacing: 0))
    }
}
