//
//  GasPrice.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/22/22.
//

import Foundation

struct GasPrice: Codable {
    let network: Network?
    let gasPrices: NetworkGasPrice?
    let historyChart: [NetworkGasHistoryChart]?
}

// MARK: - Current
struct NetworkGasPrice: Codable {
    let timestamp: String?
    let lastBlock, avgTime, avgTx, avgGas: Int?
    let speeds: [NetworkGasSpeed]?
}

struct NetworkGasSpeed: Codable {
    let acceptance, maxFeePerGas, maxPriorityFeePerGas, baseFee, estimatedFee: Int?
}

struct NetworkGasHistoryChart: Codable {
    let timestamp: String?
    let samples: Int?
    let avgGas: Int?
    let gasPrice: OCLH?
    let tokenPrice: OCLH?
    let txFee: OCLH?
}

struct OCLH: Codable {
    let open, close, low, high: Int?
}
// MARK: - Trend
struct EthGasTrend: Codable {
    let block, timestamp: Int?
    let date: String?
    let baseFee: Double?
}

// MARK: - Socket Eth Gas Prices
struct GasSocketPrice: Codable, Equatable {

    let source: String
    let datetime: String
    let rapid: Double?
    let fast: Double
    let standard: Double
    let slow: Double

}
