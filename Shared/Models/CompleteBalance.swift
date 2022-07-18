//
//  CompleteBalance.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 3/14/22.
//

import Foundation

// MARK: - CompleteBalance
struct CompleteBalance: Codable, Hashable, Equatable {

    static func == (lhs: CompleteBalance, rhs: CompleteBalance) -> Bool {
        return lhs.network == rhs.network && lhs.nativeBalance == rhs.nativeBalance
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(network)
        hasher.combine(nativeBalance)
    }

    let network: String?
    var totalBalance: Double?
    var nativeBalance: TokenModel?
    var tokens: [TokenModel]?
    let nfts: Nfts?
    let transactions: AccountTransactions?

}

// MARK: - TokenModel
struct TokenModel: Codable, Hashable {

    static func == (lhs: TokenModel, rhs: TokenModel) -> Bool {
        return lhs.tokenAddress == rhs.tokenAddress && lhs.name == rhs.name
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(tokenAddress)
        hasher.combine(name)
    }

    let tokenAddress, name, symbol, createdAt: String?
    let imageLarge, imageThumb, imageSmall, image, network: String?
    let externalId, description, genesisDate, countryOrigin: String?
    let telegramChannelID, twitterHandle, bitcoinTalkUrl, facebookUsername: String?
    let subredditUrl, publicNotice: String?
    var athDate, atlDate, lastUpdated, portfolioDiversity: String?
    let categories, discordUrl, blockchainUrl, projectUrl, githubUrl, bitbucketUrl, officialForumURL: [String?]?
    var decimals, overallRank, marketCapRank: Int?
    var fullyDilutedValuation, marketCap: Int?
    var nativeBalance, totalBalance: Double?
    var currentPrice, totalVolume, high24H, low24H, priceChange24H: Double?
    var priceChangePercentage24H, marketCapChange24H, marketCapChangePercentage24H, circulatingSupply: Double?
    var totalSupply, maxSupply: Double?
    var ath, athChangePercentage: Double?
    var atl, atlChangePercentage: Double?
    var priceChangePercentage1h, priceChangePercentage24h: Double?
    var priceChangePercentage7d, priceChangePercentage1y: Double?
    let allAddress: AllAddress?
    let roi: RoiModel?
    var priceGraph: GraphModel?

    enum CodingKeys: String, CodingKey {
        case tokenAddress = "token_address"
        case name, symbol, decimals, categories
        case nativeBalance, network, description
        case createdAt, image
        case ath, atl, roi, totalBalance
        case imageLarge = "image_large"
        case imageSmall = "image_small"
        case imageThumb = "image_thumb"
        case externalId = "external_id"
        case marketCapRank = "market_cap_rank"
        case overallRank = "overall_rank"
        case allAddress = "all_address"
        case genesisDate = "genesis_date"
        case countryOrigin = "country_origin"
        case discordUrl = "discord_url"
        case blockchainUrl = "blockchain_url"
        case projectUrl = "project_url"
        case telegramChannelID = "telegram_channel_id"
        case twitterHandle = "twitter_handle"
        case bitcoinTalkUrl = "bitcointalk_url"
        case facebookUsername = "facebook_username"
        case githubUrl = "github_url"
        case officialForumURL = "official_forum_url"
        case subredditUrl = "subreddit_url"
        case bitbucketUrl = "bitbucket_url"
        case publicNotice = "public_notice"
        case currentPrice = "current_price"
        case marketCap = "market_cap"
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
        case portfolioDiversity = "portfolio_diversity"

    }
}
