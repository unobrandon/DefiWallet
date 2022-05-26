//
//  ExchangeModel.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 5/25/22.
//

import Foundation

struct ExchangeModel: Codable, Hashable {

    static func == (lhs: ExchangeModel, rhs: ExchangeModel) -> Bool {
        return lhs.objectID == rhs.objectID && lhs.externalID == rhs.externalID
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(objectID)
        hasher.combine(externalID)
    }

    let externalID, name, exchangeModelDescription: String?
    let yearEstablished: Int?
    let country: String?
    let url: String?
    let image: String?
    let hasTradingIncentive: Bool?
    let trustScore, trustScoreRank: Int?
    let tradeVolume24HBtc, tradeVolume24HBtcNormalized: Double?
    let createdAt, updatedAt, objectID: String?

    enum CodingKeys: String, CodingKey {
        case externalID = "external_id"
        case name
        case exchangeModelDescription = "description"
        case yearEstablished = "year_established"
        case country, url, image
        case hasTradingIncentive = "has_trading_incentive"
        case trustScore = "trust_score"
        case trustScoreRank = "trust_score_rank"
        case tradeVolume24HBtc = "trade_volume_24h_btc"
        case tradeVolume24HBtcNormalized = "trade_volume_24h_btc_normalized"
        case createdAt, updatedAt
        case objectID = "objectId"
    }

}
