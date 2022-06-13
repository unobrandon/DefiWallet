//
//  ExchangeDetailsModel.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 6/12/22.
//

import Foundation

// MARK: - ExchangeDetails

struct ExchangeDetails: Codable {

    let tickers: [ExchangeTicker]?
    let chartTime: [Int]?
    let chartValue: [Double]?

}

// MARK: - ExchangeTicker

struct ExchangeTicker: Codable, Hashable {

    static func == (lhs: ExchangeTicker, rhs: ExchangeTicker) -> Bool {
        return lhs.coinID == rhs.coinID && lhs.bidAskSpreadPercentage == rhs.bidAskSpreadPercentage
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(coinID)
        hasher.combine(bidAskSpreadPercentage)
    }

    let base, target: String?
    let market: ExchangeTickerMarket?
    let last, volume: Double?
    let convertedLast, convertedVolume: [String: Double]?
    let trustScore: String?
    let bidAskSpreadPercentage: Double?
    let timestamp, lastTradedAt, lastFetchAt: String?
    let isAnomaly, isStale: Bool?
    let tradeURL: String?
    let coinID, targetCoinID: String?

    enum CodingKeys: String, CodingKey {
        case base, target, market, last, volume
        case convertedLast = "converted_last"
        case convertedVolume = "converted_volume"
        case trustScore = "trust_score"
        case bidAskSpreadPercentage = "bid_ask_spread_percentage"
        case timestamp
        case lastTradedAt = "last_traded_at"
        case lastFetchAt = "last_fetch_at"
        case isAnomaly = "is_anomaly"
        case isStale = "is_stale"
        case tradeURL = "trade_url"
        case coinID = "coin_id"
        case targetCoinID = "target_coin_id"
    }

}

// MARK: - ExchangeTickerMarket

struct ExchangeTickerMarket: Codable {

    let name, identifier: String?
    let hasTradingIncentive: Bool?
    let logo: String?

    enum CodingKeys: String, CodingKey {
        case name, identifier
        case hasTradingIncentive = "has_trading_incentive"
        case logo
    }

}
