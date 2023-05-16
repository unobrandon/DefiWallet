//
//  AccountTransactions.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 6/13/22.
//

import Foundation

// MARK: - AccountTransactions

struct AccountTransactions: Codable {

    let total, page, pageSize: Int?
    let cursor: String?
    let result: [TransactionResult]?

    enum CodingKeys: String, CodingKey {
        case total, page
        case pageSize = "page_size"
        case cursor, result
    }

}

// MARK: - TransactionResult

struct TransactionResult: Codable, Hashable {

    static func == (lhs: TransactionResult, rhs: TransactionResult) -> Bool {
        return lhs.hash == rhs.hash && lhs.blockHash == rhs.blockHash
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(hash)
        hasher.combine(blockHash)
    }

    let hash, nonce, address: String?
    let fromAddress, network, name, symbol: String?
    let type: TransactionType?
    let direction: TransactionDirection?
    let toAddress, gas, gasPrice, externalId, timestamp: String?
    let imageSmall, imageLarge, hashingAlgorithm, tokenContract: String?
    let input, receiptCumulativeGasUsed, receiptGasUsed, transactionHash: String?
    let receiptStatus, blockNumber, blockHash, publicNotice: String?
    let amount, value: Double?
    let transferIndex: [Int]?
    let marketCapRank, overallRank, retries: Int?
    let confirmed: Bool?

    enum CodingKeys: String, CodingKey {
        case hash, nonce, address, confirmed, fromAddress, toAddress
        case amount, value, gas, type, retries, timestamp
        case gasPrice = "gas_price"
        case name = "token_name"
        case externalId = "external_id"
        case input, network, direction
        case symbol = "token_symbol"
        case imageSmall = "image_small"
        case imageLarge = "image_large"
        case marketCapRank = "market_cap_rank"
        case overallRank = "overall_rank"
        case hashingAlgorithm = "hashing_algorithm"
        case publicNotice = "public_notice"
        case receiptCumulativeGasUsed
        case receiptGasUsed
        case tokenContract = "token_contract"
        case receiptStatus = "receipt_status"
        case blockNumber = "block_number"
        case blockHash = "block_hash"
        case transferIndex = "transfer_index"
        case transactionHash = "transaction_hash"
    }

}

enum TransactionType: String, Codable {
    case native
    case token
}

enum TransactionDirection: String, Codable {
    case sent
    case received
    case swap
}
