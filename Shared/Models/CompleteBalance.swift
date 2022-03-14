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

}

// MARK: - TokenBalance
struct TokenBalance: Codable {
    let tokenAddress, name, symbol: String?
    let logo, thumbnail: JSONNull?
    let decimals, balance: String?

    enum CodingKeys: String, CodingKey {
        case tokenAddress = "token_address"
        case name, symbol, logo, thumbnail, decimals, balance
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public func hash(into hasher: inout Hasher) {
        // No-op
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }

}
