//
//  TransactionHistory.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/15/22.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let accountBalance = try? newJSONDecoder().decode(AccountBalance.self, from: jsonData)

//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseAccountBalance { response in
//     if let accountBalance = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

// MARK: - TransactionHistory
struct TransactionHistory: Codable {
    let error: [String]?
    let data: [HistoryData]?
}

// MARK: - Datum
struct HistoryData: Decodable, Encodable, Hashable {

    static func == (lhs: HistoryData, rhs: HistoryData) -> Bool {
        return lhs.hash == rhs.hash && lhs.blockNumber == rhs.blockNumber
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(hash)
        hasher.combine(blockNumber)
    }

    let network: Network
    let hash: String
    let blockNumber: Int
    let name: Name?
    let direction: Direction
    let timeStamp, symbol, address, amount: String
    let from, destination, contract: String
    let subTransactions: [SubTransaction]?
    let nonce: String?
    let gasPrice, gasLimit: Double
    let input: String?
    let gas: Double?
    let txSuccessful: Bool
    let account: String
    let fromEns, accountEns, destinationEns: String?

}

enum Direction: String, Codable {
    case exchange
    case incoming
    case outgoing
}

enum Name: String, Codable {
    case exchange = "Exchange"
    case receive = "Receive"
    case send = "Send"
}

enum Network: String, Codable {
    case avalanche = "avalanche"
    case binanceSmartChain = "binance-smart-chain"
    case ethereum = "ethereum"
    case polygon = "polygon"
    case fantom = "fantom"
}

// MARK: - SubTransaction
struct SubTransaction: Codable {
    let type: Direction?
    let symbol: String?
    let amount: Double?
    let address: String?
}
