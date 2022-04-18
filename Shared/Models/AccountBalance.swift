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
import Alamofire

// MARK: - AccountBalance
struct AccountBalance: Codable {

    let error: [String]?
    let completeBalance: [CompleteBalance]?

}

struct AccountPortfolio: Codable, Hashable {

    static func == (lhs: AccountPortfolio, rhs: AccountPortfolio) -> Bool {
        return lhs.absoluteChange24h == rhs.absoluteChange24h && lhs.relativeChange24h == rhs.relativeChange24h
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(absoluteChange24h)
        hasher.combine(relativeChange24h)
    }

    let arbitrumAssetsValue, assetsValue, auroraAssetsValue: Double?
    let avalancheAssetsValue, borrowedValue, bscAssetsValue, depositedValue: Double?
    let ethereumAssetsValue, fantomAssetsValue, lockedValue, loopringAssetsValue: Double?
    let nftFloorPriceValue, nftLastPriceValue, optimismAssetsValue, polygonAssetsValue: Double?
    let solanaAssetsValue, stakedValue, totalValue, xdaiAssetsValue: Double?
    let absoluteChange24h, relativeChange24h: Double?
}

struct ChartValue: Codable {

    let timestamp: Int
    let amount: Double

}
