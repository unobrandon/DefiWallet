//
//  SwapDetailView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 8/27/22.
//

import SwiftUI

struct SwapDetailView: View {

    @EnvironmentObject private var walletRouter: WalletCoordinator.Router

    @ObservedObject private var service: AuthenticatedServices
    @ObservedObject private var store: WalletService

    private let swapQuote: SwapQuote

    init(swapQuote: SwapQuote, service: AuthenticatedServices) {
        self.service = service
        self.store = service.wallet
        self.swapQuote = swapQuote
    }

    var body: some View {
        BackgroundColorView(style: service.themeStyle, {
            ScrollView {
                VStack(alignment: .center, spacing: 5) {
                    ListSection(title: "Tokens", style: service.themeStyle) {

                    }
                }
            }
        })
        .navigationBarTitle("Swap Overview", displayMode: .inline)
        .onAppear {
            DispatchQueue.main.async {
                Tool.hiddenTabBar()
            }
        }
    }

}
