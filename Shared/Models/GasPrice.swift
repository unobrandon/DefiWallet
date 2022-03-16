//
//  GasPrice.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/22/22.
//

import Foundation

struct GasPrice: Codable, Equatable {

    let eip1559: Bool
    let standard: Int
    let fast: Int
    let instant: Int
    let network: Network

}

struct EthGasPriceTrends: Codable {
    let trend: [EthGasTrend]?
    let current: EthGasPrices?
}

// MARK: - Current
struct EthGasPrices: Codable {
    let eip1559: Bool?
    let standard, fast, instant: PostLondon?
}

// MARK: - Fast
struct PostLondon: Codable {
    let baseFeePerGas, maxPriorityFeePerGas, maxFeePerGas: Int?
}

// MARK: - Trend
struct EthGasTrend: Codable {
    let block, timestamp: Int?
    let date: String?
    let baseFee: Double?
}
