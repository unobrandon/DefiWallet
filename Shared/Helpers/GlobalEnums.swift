//
//  GlobalEnums.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 4/5/22.
//

import Foundation

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

enum SocketResponses: String, Codable {
    case testSend = "test_send"
    case testAnswer = "test_answer"
    case priceUpdate = "price_update"
    case swapQuote = "swap_quote"
    case marketCharts = "market_charts"
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
