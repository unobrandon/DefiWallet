//
//  EthereumServiceDelegate.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/19/22.
//

import SwiftUI
import web3swift

extension EthereumService: Web3SocketDelegate {

    func socketConnected(_ headers: [String : String]) {
        print("websocket connected!!!: \(headers)")
        self.connectionStatus = .connected
    }

    func received(message: Any) {
        print("received new message!!!: \(message)")
    }

    func gotError(error: Error) {
        print("received eth error: \(error)")
        self.connectionStatus = .error
    }

}
