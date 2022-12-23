//
//  ExchangeModel.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 5/25/22.
//

import Foundation

struct ExchangeModel: Codable, Hashable {

    static func == (lhs: ExchangeModel, rhs: ExchangeModel) -> Bool {
        return lhs.objectID == rhs.objectID && lhs.externalId == rhs.externalId
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(objectID)
        hasher.combine(externalId)
    }

    let externalId, name, description: String?
    let country: String?
    let url, image: String?
    let ytVideoId: String?
    let hasTradingIncentive: Bool?
    let trustScore, trustScoreRank, yearEstablished: Int?
    let tradeVolume24HBtc, tradeVolume24HBtcNormalized: Double?
    let createdAt, updatedAt, objectID: String?

    enum CodingKeys: String, CodingKey {
        case externalId = "external_id"
        case name
        case description = "description"
        case yearEstablished = "year_established"
        case country, url, image
        case ytVideoId = "yt_video_id"
        case hasTradingIncentive = "has_trading_incentive"
        case trustScore = "trust_score"
        case trustScoreRank = "trust_score_rank"
        case tradeVolume24HBtc = "trade_volume_24h_btc"
        case tradeVolume24HBtcNormalized = "trade_volume_24h_btc_normalized"
        case createdAt, updatedAt
        case objectID = "objectId"
    }

}
