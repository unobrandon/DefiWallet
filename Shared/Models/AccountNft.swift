//
//  AccountNFTs.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 3/10/22.
//

import Foundation

// MARK: - AccountNft
struct AccountNft: Codable {

    let network: String?
    let nfts: Nfts?

}

// MARK: - Nfts
struct Nfts: Codable {

    let total, page, pageSize: Int?
    let cursor: String?
    let allNfts: [NftResult]?
    let status: String?

    enum CodingKeys: String, CodingKey {
        case total, page
        case pageSize = "page_size"
        case cursor, allNfts, status
    }

}

// MARK: - NftResult
struct NftResult: Identifiable, Codable, Hashable {

    static func == (lhs: NftResult, rhs: NftResult) -> Bool {
        return lhs.tokenAddress == rhs.tokenAddress && lhs.tokenID == rhs.tokenID
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(tokenAddress)
        hasher.combine(tokenID)
    }

    var id = UUID().uuidString
    let tokenAddress, tokenID, blockNumberMinted, ownerOf: String?
    let blockNumber, amount, contractType, name: String?
    let symbol, network: String?
    let tokenURI: String?
    let metadata: NftMetadata?
    let syncedAt: String?
    let isValid, syncing, frozen: Int?

    enum CodingKeys: String, CodingKey {
        case tokenAddress = "token_address"
        case tokenID = "token_id"
        case blockNumberMinted = "block_number_minted"
        case ownerOf = "owner_of"
        case blockNumber = "block_number"
        case amount, network
        case contractType = "contract_type"
        case name, symbol
        case tokenURI = "token_uri"
        case metadata
        case syncedAt = "synced_at"
        case isValid = "is_valid"
        case syncing, frozen
    }

}

// MARK: - NftMetadata
struct NftMetadata: Codable, Hashable {

    static func == (lhs: NftMetadata, rhs: NftMetadata) -> Bool {
        return lhs.name == rhs.name && lhs.image == rhs.image
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(image)
    }

    let name, image, imageUrl, imagePreview, description, externalUrl, url: String?
    let isNormalized: Bool?
//    let attributes: NftAttributes?

    enum CodingKeys: String, CodingKey {
        case description
        case name, image, url
        case externalUrl = "external_url"
        case imagePreview = "image_preview"
        case isNormalized = "is_normalized"
        case imageUrl = "image_url"
    }

}

// MARK: - NftAttributes
struct NftAttributes: Codable, Hashable {

    static func == (lhs: NftAttributes, rhs: NftAttributes) -> Bool {
        return lhs.traitType == rhs.traitType && lhs.value == rhs.value
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(traitType)
        hasher.combine(value)
    }

    let traitType: String?
    let value: String?

    enum CodingKeys: String, CodingKey {
        case traitType = "trait_type"
        case value
    }

}
