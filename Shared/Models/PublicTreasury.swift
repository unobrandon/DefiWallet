//
//  PublicTreasury.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 6/7/22.
//

import Foundation

// MARK: - PublicTreasury
struct PublicTreasury: Codable {
    let totalHoldings, totalValueUsd, marketCapDominance: Double?
    let companies: [Company]?

    enum CodingKeys: String, CodingKey {
        case totalHoldings = "total_holdings"
        case totalValueUsd = "total_value_usd"
        case marketCapDominance = "market_cap_dominance"
        case companies
    }
}

// MARK: - Company
struct Company: Codable, Hashable {

    static func == (lhs: Company, rhs: Company) -> Bool {
        return lhs.symbol == rhs.symbol && lhs.name == rhs.name
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(symbol)
        hasher.combine(name)
    }

    let name, symbol, country: String?
    let totalHoldings, totalEntryValueUsd, totalCurrentValueUsd: Int?
    let percentageOfTotalSupply: Double?

    enum CodingKeys: String, CodingKey {
        case name, symbol, country
        case totalHoldings = "total_holdings"
        case totalEntryValueUsd = "total_entry_value_usd"
        case totalCurrentValueUsd = "total_current_value_usd"
        case percentageOfTotalSupply = "percentage_of_total_supply"
    }
}
