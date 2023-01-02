//
//  AccountBalance.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/15/22.
//
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//

import Foundation

// MARK: - AccountBalance
struct AccountBalance: Codable {

    let error: [String]?
    var completeBalance: [CompleteBalance]?
    var portfolioTotal: Double?
    var portfolio24hChange: Double?
    var portfolio24hPercentChange: Double?

}

struct ChartValue: Codable, Identifiable {

    let id = UUID()
    let timestamp: Int
    let amount: Double

    enum CodingKeys: String, CodingKey {
        case timestamp
        case amount
    }
}
