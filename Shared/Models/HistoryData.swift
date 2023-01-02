//
//  HistoryData.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 12/23/22.
//

import Foundation

// MARK: - HistoryData
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

// MARK: - SubTransaction
struct SubTransaction: Codable {
    let type: Direction?
    let symbol: String?
    let amount: Double?
    let address: String?
}
