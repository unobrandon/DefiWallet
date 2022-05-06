//
//  TokenDetailView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 4/11/22.
//

import SwiftUI

struct TokenDetailView: View {

    @EnvironmentObject private var walletRouter: WalletCoordinator.Router

    @ObservedObject private var service: AuthenticatedServices
    @ObservedObject private var walletStore: WalletService
    @State private var tokenDetail: CoinMarketCap?
    @State private var externalId: String?

    init(tokenDetail: CoinMarketCap?, externalId: String?, service: AuthenticatedServices) {
        self.service = service
        self.externalId = externalId
        self.tokenDetail = tokenDetail
        self.walletStore = service.wallet
    }

    var body: some View {
        BackgroundColorView(style: service.themeStyle, {
            ScrollView(.vertical, showsIndicators: false) {
                Text(externalId ?? "hello")
            }
        })
        .navigationBarTitle(tokenDetail?.name ?? "Details", displayMode: .inline)
        .onAppear {
            DispatchQueue.main.async {
                Tool.hiddenTabBar()
            }

//            if let id = externalId {
            service.market.emitFullInfoAssetSocket("0x0f5d2fb29fb7d3cfee444a200298f468908cc942", currency: service.currentUser.currency)
//            }
        }
    }

}
