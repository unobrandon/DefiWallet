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

    let hash, nonce: String?
    let fromAddress, network: String?
    let direction: TransactionDirection?
    let toAddress, value, gas, gasPrice: String?
    let input, receiptCumulativeGasUsed, receiptGasUsed: String?
    let receiptStatus, blockNumber, blockHash: String?
    let transferIndex: [Int]?
    let blockTimestamp: Int?

    enum CodingKeys: String, CodingKey {
        case hash, nonce
        case fromAddress = "from_address"
        case toAddress = "to_address"
        case value, gas
        case gasPrice = "gas_price"
        case input, network, direction
        case receiptCumulativeGasUsed = "receipt_cumulative_gas_used"
        case receiptGasUsed = "receipt_gas_used"
        case receiptStatus = "receipt_status"
        case blockTimestamp = "block_timestamp"
        case blockNumber = "block_number"
        case blockHash = "block_hash"
        case transferIndex = "transfer_index"
    }

}

enum TransactionDirection: String, Codable {

    case sent
    case received
    case swap

}
