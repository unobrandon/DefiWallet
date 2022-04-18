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
