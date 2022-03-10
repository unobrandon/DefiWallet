//
//  AccountNFTs.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 3/10/22.
//

import Foundation

struct AccountNfts: Codable {
    let error: [String]?
    let networkNfts: [NetworkNfts]?
}

struct NetworkNfts: Decodable, Encodable, Hashable {

    static func == (lhs: NetworkNfts, rhs: NetworkNfts) -> Bool {
        return lhs.network == rhs.network
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(network)
    }

    let network: String?
    let networkNfts: [NftInfo]?

    enum CodingKeys: String, CodingKey {
        case network
        case networkNfts = "nfts"
    }
}

struct NftInfo: Decodable, Encodable, Hashable {

    static func == (lhs: NftInfo, rhs: NftInfo) -> Bool {
        return lhs.status == rhs.status && lhs.cursor == rhs.cursor
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(status)
        hasher.combine(cursor)
    }

    let total: Int?
    let page: Int?
    let page_size: Int?
    let cursor: String?
    let status: String?
    let result: [NftData]?

//    enum CodingKeys: String, CodingKey {
//        case nft = "result"
//        case total, page, page_size, cursor
//    }
}

struct NftData: Codable {
    let token_address, token_id, block_number_minted, owner_of, block_number, amount, contract_type, name, symbol, token_uri, metadata, synced_at: String?
    let is_valid, syncing, frozen: Int?

//    enum CodingKeys: String, CodingKey {
//        case tokenAddress = "token_address"
//        case name, symbol, logo, thumbnail, decimals, balance
//    }
}
