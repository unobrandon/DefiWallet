//
//  CoinByMarketCap.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 3/24/22.
//

import Foundation

struct CoinsByMarketCap: Codable {
    let error: [String]?
    let marketCap: [TokenDetails]?
}

struct TokenDetails: Codable, Hashable {

    static func == (lhs: TokenDetails, rhs: TokenDetails) -> Bool {
        return lhs.id == rhs.id && lhs.marketCapRank == rhs.marketCapRank
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(marketCapRank)
    }

    let id, symbol, name, tokenDescription, createdAt: String?
    let image, imageLarge: String?
    let hashingAlgorithm, telegramChannelID, twitterHandle, facebookUsername: String?
    let discordURL, blockchainURL, projectURL: [String]?
    let githubURL, officialForumURL, bitbucketURL: [String]?
    var currentPrice: Double?
    var marketCap, marketCapRank, overallRank: Int?
    var fullyDilutedValuation: Int?
    var totalVolume, high24H, low24H, priceChange24H: Double?
    var priceChangePercentage24H, marketCapChange24H, marketCapChangePercentage24H, circulatingSupply: Double?
    var totalSupply, maxSupply: Double?
    var ath, athChangePercentage: Double?
    var athDate, genesisDate, countryOrigin: String?
    var atl, atlChangePercentage: Double?
    var atlDate, subredditURL: String?
    var lastUpdated, publicNotice: String?
    let roi: RoiModel?
    let allAddress: AllAddress?
    var priceGraph: GraphModel?
    var tokenDescriptor: TokenDescriptor?

    enum CodingKeys: String, CodingKey {
        case id, symbol, name, image, createdAt
        case imageLarge = "image_large"
        case tokenDescription = "description"
        case overallRank = "overall_rank"
        case hashingAlgorithm = "hashing_algorithm"
        case allAddress = "all_address"
        case genesisDate = "genesis_date"
        case countryOrigin = "country_origin"
        case discordURL = "discord_url"
        case blockchainURL = "blockchain_url"
        case projectURL = "project_url"
        case telegramChannelID = "telegram_channel_id"
        case twitterHandle = "twitter_handle"
        case facebookUsername = "facebook_username"
        case githubURL = "github_url"
        case officialForumURL = "official_forum_url"
        case subredditURL = "subreddit_url"
        case bitbucketURL = "bitbucket_url"
        case publicNotice = "public_notice"
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
        case ath, atl, roi
        case athChangePercentage = "ath_change_percentage"
        case athDate = "ath_date"
        case atlChangePercentage = "atl_change_percentage"
        case atlDate = "atl_date"
        case lastUpdated = "last_updated"
        case priceGraph = "sparkline_in_7d"
        case tokenDescriptor
    }
}

struct RoiModel: Codable {
    let times: Double?
    let currency: Currency?
    let percentage: Double?
}

struct GraphModel: Codable {

    var price: [Double]
    enum CodingKeys: String, CodingKey {
        case price
    }
}

enum Currency: String, Codable {
    case btc
    case eth
    case usd
}
