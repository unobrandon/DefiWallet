//
//  CurrentUser.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/13/22.
//

import Foundation

struct CurrentUser: Codable, Equatable {

    let objectId: String?
    let sessionToken: String
    let address: String
    let mediumAddress: String
    let shortAddress: String
    let secretPhrase: [String]
    let password: String
    let username: String?
    let avatar: String?
    let miniAvatar: String?
    let currency: String
    let createdAt: String
    let updatedAt: String
    let wallet: Wallet

}

struct RegisteredUser: Codable, Equatable {

    let objectId: String
    let username: String
    let ethAddress: String
    let accounts: [String]
    let createdAt: String
    let currency: String
    let sessionToken: String
    let updatedAt: String

}
