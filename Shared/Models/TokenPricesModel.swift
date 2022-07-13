//
//  TokenPricesModel.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 7/6/22.
//

import Foundation

// MARK: - TokenPricesModel
struct TokenPricesModel: Codable, Hashable {

    static func == (lhs: TokenPricesModel, rhs: TokenPricesModel) -> Bool {
        return lhs.currentPrice == rhs.currentPrice && lhs.marketCapRank == rhs.marketCapRank
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(currentPrice)
        hasher.combine(marketCapRank)
    }
    
    let externalId, lastUpdated: String?
    let athDate, atlDate: String?
    let fullyDilutedValuation, marketCap, marketCapRank: Int?
    let currentPrice, totalVolume, high24H, low24H, priceChange24H: Double?
    let priceChangePercentage24H, marketCapChange24H, marketCapChangePercentage24H, circulatingSupply: Double?
    let totalSupply, maxSupply: Double?
    let atlChangePercentage, athChangePercentage: Double?
    let priceChangePercentage1h, priceChangePercentage24h: Double?
    let priceChangePercentage7d, priceChangePercentage1y: Double?
    var priceGraph: GraphModel?

    enum CodingKeys: String, CodingKey {
        case externalId = "id"
        case currentPrice = "current_price"
        case marketCap = "market_cap"
        case marketCapRank = "market_cap_rank"
        case fullyDilutedValuation = "fully_diluted_valuation"
        case totalVolume = "total_volume"
        case high24H = "high_24h"
        case low24H = "low_24h"
        case priceChange24H = "price_change_24h"
        case priceChangePercentage24H = "price_change_percentage_24h"
        case marketCapChange24H = "market_cap_change_24h"
        case marketCapChangePercentage24H = "market_cap_change_percentage_24h"
        case circulatingSupply = "circulating_supply"
        case totalSupply = "total_supply"
        case maxSupply = "max_supply"
        case athChangePercentage = "ath_change_percentage"
        case athDate = "ath_date"
        case atlChangePercentage = "atl_change_percentage"
        case atlDate = "atl_date"
        case lastUpdated = "last_updated"
        case priceGraph = "sparkline_in_7d"
        case priceChangePercentage1h = "price_change_percentage_1h_in_currency"
        case priceChangePercentage24h = "price_change_percentage_24h_in_currency"
        case priceChangePercentage7d = "price_change_percentage_7d_in_currency"
        case priceChangePercentage1y = "price_change_percentage_1y_in_currency"

    }

}
