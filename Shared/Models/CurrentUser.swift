//
//  CurrentUser.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/13/22.
//

import Foundation

struct CurrentUser: Codable, Equatable {

    let id: String
    let address: String
    let mediumAddress: String
    let shortAddress: String
    let secretPhrase: [String]
    let password: String
    let username: String?
    let avatar: String?
    let miniAvatar: String?
    let currency: String
    let wallet: Wallet

}
