//
//  CurrentUser.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/13/22.
//

import Foundation

struct CurrentUser: Codable, Equatable {

    let accessToken: String
    let walletAddress: String
    let secretPhrase: String
    let password: String
    let username: String?
    let avatar: String?
    let accountValue: String?
    let wallet: Wallet

}
