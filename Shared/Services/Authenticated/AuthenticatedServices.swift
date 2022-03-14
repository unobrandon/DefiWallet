//
//  AuthenticatedServices.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/15/22.
//

import Foundation
import web3swift

class AuthenticatedServices: ObservableObject {

    // MARK: screen services
    var wallet: WalletService = WalletService()
    var market: MarketsService = MarketsService()
    var discover: DiscoverService = DiscoverService()
    var invest: InvestService = InvestService()
    var profile: ProfileService = ProfileService()

    // MARK: network delegates
    var ethereum: EthereumService

    // MARK: stored values
    @Published var themeStyle: AppStyle = .shadow
    @Published var currentUser: CurrentUser
    @Published var macTabStatus: MacTabStatus

    enum MacTabStatus: String, Equatable {
        case wallet
        case markets
        case discover
        case invest
        case profile
        case settings
    }

    init(currentUser: CurrentUser) {
        self.currentUser = currentUser
        self.ethereum = EthereumService(currentUser: currentUser)

        self.macTabStatus = .wallet
    }

}
