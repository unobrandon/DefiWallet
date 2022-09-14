//
//  TokenDescriptor.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 5/23/22.
//

import Foundation

struct TokenDescriptor: Codable, Hashable {

    static func == (lhs: TokenDescriptor, rhs: TokenDescriptor) -> Bool {
        return lhs.objectID == rhs.objectID && lhs.externalID == rhs.externalID
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(objectID)
        hasher.combine(externalID)
    }

    let allAddress: AllAddress?
    let projectURL, blockchainURL, categories: [String]?
    let officialForumURL, discordURL, blogURL, githubURL, bitbucketURL: [String]?
    let externalID, symbol, name, hashingAlgorithm: String?
    let tokenDescription, ethAddress, xdaiAddress, fantomAddress, avaxAddress, solanaAddress, moonriverAddress, moonbeamAddress, publicNotice: String?
    let twitterHandle, facebookUsername, telegramChannelID: String?
    let subredditURL: String?
    let imageThumb, imageSmall, imageLarge: String?
    let overallRank: Int?
    let genesisDate: String?
    let marketCapRank: Int?
    let countryOrigin, createdAt, updatedAt, objectID: String?

    enum CodingKeys: String, CodingKey {
        case allAddress = "all_address"
        case projectURL = "project_url"
        case categories = "categories"
        case blockchainURL = "blockchain_url"
        case officialForumURL = "official_forum_url"
        case discordURL = "discord_url"
        case blogURL = "blog_url"
        case githubURL = "github_url"
        case bitbucketURL = "bitbucket_url"
        case externalID = "external_id"
        case symbol, name
        case hashingAlgorithm = "hashing_algorithm"
        case tokenDescription = "description"
        case ethAddress = "eth_address"
        case fantomAddress = "fantom_address"
        case avaxAddress = "avax_address"
        case solanaAddress = "solana_address"
        case moonriverAddress = "moonriver_address"
        case moonbeamAddress = "moonbeam_address"
        case xdaiAddress = "xdai_address"
        case publicNotice = "public_notice"
        case twitterHandle = "twitter_handle"
        case facebookUsername = "facebook_username"
        case telegramChannelID = "telegram_channel_id"
        case subredditURL = "subreddit_url"
        case imageThumb = "image_thumb"
        case imageSmall = "image_small"
        case imageLarge = "image_large"
        case overallRank = "overall_rank"
        case genesisDate = "genesis_date"
        case marketCapRank = "market_cap_rank"
        case countryOrigin = "country_origin"
        case createdAt, updatedAt
        case objectID = "objectId"
    }
}

struct AllAddress: Codable, Hashable {

    static func == (lhs: AllAddress, rhs: AllAddress) -> Bool {
        return lhs.ethereum == rhs.ethereum && lhs.polygon_pos == rhs.polygon_pos
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(ethereum)
        hasher.combine(polygon_pos)
    }

    let ethereum, xdai, polygon_pos, solana, moonriver, moonbeam, fantom, avalanche, huobi_token, binance, kucoin, arbitrum, okex, cronos, harmony : String?

    enum CodingKeys: String, CodingKey {
        case ethereum
        case xdai
        case solana
        case moonriver
        case moonbeam
        case fantom
        case avalanche
        case polygon_pos = "polygon-pos"
        case huobi_token = "huobi-token"
        case binance = "binance-smart-chain"
        case kucoin = "kucoin-community-chain"
        case arbitrum = "arbitrum-one"
        case okex = "okex-chain"
        case cronos
        case harmony = "harmony-shard-0"
    }

}
