//
//  TokenBalance.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 3/9/22.
//

import Foundation

struct AccountBalance: Codable {
    let error: [String]?
    let chainBalance: [ChainBalance]?
}

struct ChainBalance: Decodable, Encodable, Hashable {

    static func == (lhs: ChainBalance, rhs: ChainBalance) -> Bool {
        return lhs.network == rhs.network && lhs.nativeBalance == rhs.nativeBalance
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(network)
        hasher.combine(nativeBalance)
    }

    let network: String?
    let nativeBalance: String?
    let tokenBalance: [TokenBalance]?

    enum CodingKeys: String, CodingKey {
        case network, nativeBalance, tokenBalance
    }
}

struct TokenBalance: Codable {
    let tokenAddress, name, symbol, logo, thumbnail, decimals, balance: String?

    enum CodingKeys: String, CodingKey {
        case tokenAddress = "token_address"
        case name, symbol, logo, thumbnail, decimals, balance
    }
}
