//
//  TrendingCoin.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 4/2/22.
//

import Foundation

// MARK: - TrendingCoins
struct TrendingCoins: Codable {
    let coins: [TrendingCoin]?
}

// MARK: - TrendingCoin
struct TrendingCoin: Codable, Hashable, Identifiable {

    static func == (lhs: TrendingCoin, rhs: TrendingCoin) -> Bool {
        return lhs.id == rhs.id && lhs.item == rhs.item
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(item)
    }

    let id: String?
    let item: TrendingItem?
}

// MARK: - TrendingItem
struct TrendingItem: Codable, Hashable {

    static func == (lhs: TrendingItem, rhs: TrendingItem) -> Bool {
        return lhs.id == rhs.id && lhs.coinID == rhs.coinID
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(coinID)
    }

    let id: String?
    let coinID: Int?
    let name, symbol: String?
    let marketCapRank: Int?
    let thumb, small, large: String?
    let slug: String?
    let priceBtc: Double?
    let score: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case coinID = "coin_id"
        case name, symbol
        case marketCapRank = "market_cap_rank"
        case thumb, small, large, slug
        case priceBtc = "price_btc"
        case score
    }
}
