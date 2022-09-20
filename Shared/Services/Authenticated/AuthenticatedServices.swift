//
//  AuthenticatedServices.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/15/22.
//

import Foundation
import web3swift
import SocketIO
import WalletConnect

class AuthenticatedServices: ObservableObject {

    // MARK: stored values
    @Published var themeStyle: AppStyle = .border
    @Published var currentUser: CurrentUser
    @Published var macTabStatus: MacTabStatus = .wallet

    // MARK: screen services
    var wallet: WalletService
    var market: MarketsService
    var discover: DiscoverService = DiscoverService()
    var invest: InvestService = InvestService()
    var profile: ProfileService = ProfileService()

    // MARK: network delegates
//    var ethereum: EthereumService
    var socket: BackendSocketService

    enum MacTabStatus: String, Equatable {
        case wallet
        case markets
        case discover
        case invest
        case profile
        case settings
    }

    init(currentUser: CurrentUser) {
        let manager = SocketManager(socketURL: URL(string: Constants.zerionWssUrl)!,
                                    config: [.log(false), .extraHeaders(["Origin": "https://localhost:3000"]), .forceWebsockets(true), .connectParams( ["api_token": Constants.zerionApiKey]), .version(.two), .secure(true)])
        let metadata = AppMetadata(name: Constants.projectName,
                                   description: "Difi Wallet App",
                                   url: "defi.wallet",
                                   icons: [Constants.walletConnectMetadataIcon])

        self.currentUser = currentUser
        self.wallet = WalletService(currentUser: currentUser, socketManager: manager, wcMetadata: metadata)
        self.market = MarketsService(socketManager: manager)
//        self.ethereum = EthereumService(currentUser: currentUser)
        self.socket = BackendSocketService(wallet: self.wallet, market: self.market)
        self.socket.connectSocket()
    }

}
