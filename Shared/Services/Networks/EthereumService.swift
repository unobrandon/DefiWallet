//
//  EthereumService.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/19/22.
//

import SwiftUI
import web3swift
import BigInt
import SocketIO

class EthereumService: ObservableObject {

    // MARK: web3
    var web3Service: web3?
    var socketProvider: WebsocketProvider?

    var keystore: EthereumKeystoreV3?
    var hdKeystore: BIP32Keystore?
    var keystoreManager: KeystoreManager?

    var manager = SocketManager(socketURL: URL(string: "wss://api-v4.zerion.io")!,
                                config: [.log(false), .extraHeaders(["Origin": "https://localhost:3000"]), .forceWebsockets(true), .connectParams( ["api_token": "Demo.ukEVQp6L5vfgxcz4sBke7XvS873GMYHy"]), .version(.two), .secure(true)])

    var socket: SocketIOClient
    var assetsSocket: SocketIOClient

    @Published var connectionStatus: EthNetworkStatus = .undefined

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

        self.socket = manager.defaultSocket
        self.assetsSocket = manager.socket(forNamespace: "/assets")

        self.connectWebsocket(currentUser: currentUser)
    }

    deinit {
        print("deinit authenticated services")

        socketProvider?.disconnectSocket()
    }

    private func connectWebsocket(currentUser: CurrentUser) {
        self.assetsSocket.connect()

        assetsSocket.on(clientEvent: .connect) { _, _ in
            self.fetchAssetsSocket()
        }

        self.connectionStatus = .connecting
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

    private func fetchAssetsSocket() {
        print("calling assets explore-sections")

//        assetsSocket.connect(withPayload: ["address": "0x41914acD93d82b59BD7935F44f9b44Ff8381FCB9", "currency": "usd"])

//        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
        self.assetsSocket.emit("get", ["scope": ["categories", "full-info", "info"], "payload": ["asset_code": "0x6b3595068778dd592e39a122f4f5a5cf09c90fe2", "currency": "usd", "category_id": "top-gainers"]])
//        }

        assetsSocket.on("received assets categories") { data, ack in
            print("received assets categories")

            DispatchQueue.main.async {
                if let array = data as? [[String: AnyObject]], let firstDict = array.first {
                    let asset = firstDict["payload"]! as! [String: AnyObject]
                    print("received assets categories value is: \(asset)")
                }
            }
        }

        assetsSocket.on("received assets full-info") { data, _ in
            print("received assets full-info")

            DispatchQueue.main.async {
                if let array = data as? [[String: AnyObject]], let firstDict = array.first {
                    let asset = firstDict["payload"]! as! [String: AnyObject]
                    print("received assets full-info value is: \(asset)")
                }
            }
        }

        assetsSocket.on("received assets info") { data, _ in
            print("received asset / category info")

            DispatchQueue.main.async {
                if let array = data as? [[String: AnyObject]], let firstDict = array.first {
                    let asset = firstDict["payload"]! as! [String: AnyObject]
                    print("received assets category info value is: \(asset)")
                }
            }
        }
    }

}
