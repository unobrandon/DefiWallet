//
//  WalletConnectSessionInfo.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 3/20/22.
//

import Foundation

struct WCSessionInfo {

    let name: String
    let descriptionText: String
    let dappURL: String
    let iconURL: String
    let topic: String
    let chains: [String]
    let methods: [String]
    let pendingRequests: [String]

}
