//
//  GlobalEnums.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 4/5/22.
//

import Foundation

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

enum FilterHistory: Equatable {
    case all
    case ethereum
    case polygon
    case binance
    case avalanche
    case fantom
}

enum FilterCategories: String, Equatable {
    case name = "name_asc"
    case id = "id_asc"
    case volume = "volume_asc"
    case gainers = "market_cap_change_24h_desc"
    case losers = "market_cap_change_24h_asc"
    case marketCapDesc = "market_cap_desc"
    case marketCapAsc = "market_cap_asc"
}

enum FilterExchanges: String, Equatable {
    case name = "name_asc"
    case gainers = "trade_volume_24h_btc_desc"
    case losers = "trade_volume_24h_btc_asc"
    case newest = "year_established_desc"
    case oldest = "year_established_asc"
}

enum SocketResponses: String, Codable {
    case testSend = "test_send"
    case testAnswer = "test_answer"
    case priceUpdate = "price_update"
    case swapQuote = "swap_quote"
    case marketCharts = "market_charts"
    case tokenChart = "token_chart"
    case tokenPrice = "token_price"
    case portfolioChart = "portfolio_chart"
}

enum PublicTreasuryCoins: String, Equatable {
    case bitcoin
    case ethereum
}

enum NetworkStatus: Equatable {
    case connected
    case connecting
    case reconnecting
    case offline
    case unknown
}

enum JSONError : Error {
    case notArray
    case notNSDictionary
}
