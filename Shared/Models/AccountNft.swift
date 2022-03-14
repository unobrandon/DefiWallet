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
    let result: [NftResult]?
    let status: String?

    enum CodingKeys: String, CodingKey {
        case total, page
        case pageSize = "page_size"
        case cursor, result, status
    }

}

// MARK: - Result
struct NftResult: Codable {

    let tokenAddress, tokenID, blockNumberMinted, ownerOf: String?
    let blockNumber, amount, contractType, name: String?
    let symbol: String?
    let tokenURI: String?
    let metadata: String?
    let syncedAt: String?
    let isValid, syncing, frozen: Int?

    enum CodingKeys: String, CodingKey {
        case tokenAddress = "token_address"
        case tokenID = "token_id"
        case blockNumberMinted = "block_number_minted"
        case ownerOf = "owner_of"
        case blockNumber = "block_number"
        case amount
        case contractType = "contract_type"
        case name, symbol
        case tokenURI = "token_uri"
        case metadata
        case syncedAt = "synced_at"
        case isValid = "is_valid"
        case syncing, frozen
    }

}
