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

    let hash, nonce, transactionIndex: String?
    let fromAddress: String?
    let toAddress, value, gas, gasPrice: String?
    let input, receiptCumulativeGasUsed, receiptGasUsed: String?
    let receiptStatus, blockTimestamp, blockNumber, blockHash: String?
    let transferIndex: [Int]?

    enum CodingKeys: String, CodingKey {
        case hash, nonce
        case transactionIndex = "transaction_index"
        case fromAddress = "from_address"
        case toAddress = "to_address"
        case value, gas
        case gasPrice = "gas_price"
        case input
        case receiptCumulativeGasUsed = "receipt_cumulative_gas_used"
        case receiptGasUsed = "receipt_gas_used"
        case receiptStatus = "receipt_status"
        case blockTimestamp = "block_timestamp"
        case blockNumber = "block_number"
        case blockHash = "block_hash"
        case transferIndex = "transfer_index"
    }

}
