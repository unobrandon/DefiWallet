//
//  SwapTokens.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 8/31/22.
//

import Foundation

// MARK: - SwapTokens

struct SwapTokens: Codable, Hashable {

    static func == (lhs: SwapTokens, rhs: SwapTokens) -> Bool {
        return lhs.toTokenAmount == rhs.toTokenAmount && lhs.fromTokenAmount == rhs.fromTokenAmount
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(toTokenAmount)
        hasher.combine(fromTokenAmount)
    }

    let fromToken: SwapToken?
    let toToken: SwapToken?
    let toTokenAmount: String?
    let fromTokenAmount: String?
    let protocols: [SwapProtocols]?
    let transaction: SwapTransaction?

    enum CodingKeys: String, CodingKey {
        case fromToken, toToken, toTokenAmount, fromTokenAmount, protocols
        case transaction = "tx"
    }
}

// MARK: - SwapTransaction

struct SwapTransaction: Codable, Hashable {

    static func == (lhs: SwapTransaction, rhs: SwapTransaction) -> Bool {
        return lhs.from == rhs.from && lhs.toAddress == rhs.toAddress
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(from)
        hasher.combine(toAddress)
    }

    let from: String?
    let toAddress: String?
    let data: String?
    let value: String?
    let gas: Int?
    let gasPrice: String?

    enum CodingKeys: String, CodingKey {
        case from, data, value, gas, gasPrice
        case toAddress = "to"
    }
}
