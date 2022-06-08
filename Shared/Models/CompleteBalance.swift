//
//  CompleteBalance.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 3/14/22.
//

import Foundation

// MARK: - CompleteBalance
struct CompleteBalance: Codable, Hashable {

    static func == (lhs: CompleteBalance, rhs: CompleteBalance) -> Bool {
        return lhs.network == rhs.network && lhs.nativeBalance == rhs.nativeBalance
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(network)
        hasher.combine(nativeBalance)
    }

    let network, nativeBalance: String?
    let tokenBalance: [TokenBalance]?
    let nfts: Nfts?

}

// MARK: - TokenBalance
struct TokenBalance: Codable, Hashable {

    static func == (lhs: TokenBalance, rhs: TokenBalance) -> Bool {
        return lhs.tokenAddress == rhs.tokenAddress && lhs.name == rhs.name
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(tokenAddress)
        hasher.combine(name)
    }

    let tokenAddress, name, symbol: String?
    let logo, thumbnail: String?
    let balance, usd, usdTotal: String?
    let decimals: Int?

    enum CodingKeys: String, CodingKey {
        case tokenAddress = "token_address"
        case name, symbol, logo, thumbnail, decimals, balance, usd, usdTotal
    }
}
