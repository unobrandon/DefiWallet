//
//  SwapQuote.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 8/24/22.
//

import Foundation

// MARK: - SwapQuote
struct SwapQuote: Codable {

    let fromToken: SwapToken?
    let toToken: SwapToken?
    let toTokenAmount: String?
    let fromTokenAmount: String?
    let protocols: [SwapProtocols]?
    let estimatedGas: Int?
}

// MARK: - SwapProtocols

struct SwapProtocols: Codable, Hashable {

    static func == (lhs: SwapProtocols, rhs: SwapProtocols) -> Bool {
        return lhs.toTokenAddress == rhs.toTokenAddress && lhs.fromTokenAddress == rhs.fromTokenAddress
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(toTokenAddress)
        hasher.combine(fromTokenAddress)
    }

    let name: String?
    let part: Int?
    let fromTokenAddress: String?
    let toTokenAddress: String?
}
