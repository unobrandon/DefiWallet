//
//  EthereumService.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/19/22.
//

import SwiftUI
import web3swift
import BigInt

class EthereumService: ObservableObject {

    // MARK: web3
    var web3Service: web3?
    var socketProvider: WebsocketProvider?

    var keystore: EthereumKeystoreV3?
    var hdKeystore: BIP32Keystore?
    var keystoreManager: KeystoreManager?

    @Published var ethNetworkStatus: EthNetworkStatus = .undefined

    enum EthNetworkStatus: String {
        case error
        case undefined
        case connecting
        case connected
        case disconnected
    }

    init(currentUser: CurrentUser) {
        print("eth service init")

        let data = currentUser.wallet.data

        if currentUser.wallet.isHD {
            hdKeystore = BIP32Keystore(data)
            if let hdKey = hdKeystore {
                keystoreManager = KeystoreManager([hdKey])
            }
        } else {
            keystore = EthereumKeystoreV3(data)
            if let key = keystore {
                keystoreManager = KeystoreManager([key])
            }
        }

        connectWebsocket(currentUser: currentUser)
    }

    deinit {
        print("deinit authenticated services")

        socketProvider?.disconnectSocket()
    }

    private func connectWebsocket(currentUser: CurrentUser) {
        self.ethNetworkStatus = .connecting
        // Moralis node uses (socketUrl, delegate: self)
        socketProvider = WebsocketProvider(Constants.moralisBaseWssUrl + Constants.ethNodeWssUrl, delegate: self)
        // InfuraWebsocketProvider(Constants.infuraBaseWssUrl + Constants.infuraProjectId,
        // delegate: self, projectId: Constants.infuraProjectId, keystoreManager: keystoreManager)

        // FIX ME: Come back to this and change from .Ropsten -> .Mainnet
        socketProvider?.network = .Ropsten
        socketProvider?.connectSocket()

        if let provider = socketProvider {
            web3Service = web3(provider: provider)
        }
    }

}
