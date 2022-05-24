//
//  TokenCategories.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 4/8/22.
//

import Foundation

struct TokenCategory: Codable, Hashable {

    static func == (lhs: TokenCategory, rhs: TokenCategory) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
    }

    let id, externalId, name, description: String?
    let marketCap, marketCapChange24H: Double?
    let top3_Coins: [String]?
    let volume24H: Double?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, name, description
        case externalId = "external_id"
        case marketCap = "market_cap"
        case marketCapChange24H = "market_cap_change_24h"
        case top3_Coins = "top_3_coins"
        case volume24H = "volume_24h"
        case updatedAt = "updated_at"
    }

}
