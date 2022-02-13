//
//  CurrentUser.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/13/22.
//

import Foundation

struct CurrentUser: Codable, Equatable {
    let accessToken: String
    let username: String
    let ethAddress: String?
    let accountValue: String?
    let secretPhrase: String?
}
