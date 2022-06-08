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
    case gainers = "market_cap_change_24h_desc"
    case losers = "market_cap_change_24h_asc"
    case marketCapDesc = "market_cap_desc"
    case marketCapAsc = "market_cap_asc"
}

enum PublicTreasuryCoins: String, Equatable {
    case bitcoin = "bitcoin"
    case ethereum = "ethereum"
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
