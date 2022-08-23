//
//  SwappableTokens.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 8/22/22.
//

import Foundation

// MARK: - SwappableTokens
struct SwappableTokens: Codable {

    let eth, bnb, fantom, avax, polygon: [String: SwapToken]?

    enum CodingKeys: String, CodingKey {
        case eth, bnb, fantom, avax, polygon
    }

}

// MARK: - SwapToken

struct SwapToken: Codable, Hashable {

    static func == (lhs: SwapToken, rhs: SwapToken) -> Bool {
        return lhs.name == rhs.name && lhs.address == rhs.address
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(address)
    }

    let symbol, name: String?
    let decimals: Int?
    let address: String?
    let logoURI: String?
    let tags: [SwappableTag]?
    let eip2612, isFoT: Bool?
    let displayedSymbol: String?
}

enum SwappableTag: String, Codable {
    case native
    case pools
    case savings
    case tokens
}
