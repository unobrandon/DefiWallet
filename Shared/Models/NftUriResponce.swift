//
//  NftUriResponce.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 4/10/22.
//

import SwiftUI

// MARK: - NftURIResponse
struct NftURIResponse: Codable, Hashable {

    static func == (lhs: NftURIResponse, rhs: NftURIResponse) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name && lhs.nftURIResponseDescription == rhs.nftURIResponseDescription
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(nftURIResponseDescription)
    }

    let id: String?
    let name, nftURIResponseDescription: String?
    let properties: Properties?
    let externalURL: String?
    var image, image_url: String?
    let attributes: [NftAttribute]?
    let imageData, backgroundColor: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case nftURIResponseDescription = "description"
        case properties
        case externalURL = "external_url"
        case image, image_url, attributes
        case imageData = "image_data"
        case backgroundColor = "background_color"
    }

}

// MARK: - Attribute
struct NftAttribute: Codable {

    let traitType: String?
    let value: NftAttributeValue?

    enum CodingKeys: String, CodingKey {
        case traitType = "trait_type"
        case value
    }

}

enum NftAttributeValue: Codable {

    case integer(Int)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let int = try? container.decode(Int.self) {
            self = .integer(int)
            return
        }

        if let str = try? container.decode(String.self) {
            self = .string(str)
            return
        }

        throw DecodingError.typeMismatch(NftAttributeValue.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Value"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let int):
            try container.encode(int)
        case .string(let str):
            try container.encode(str)
        }
    }
}

// MARK: - Properties
struct Properties: Codable {
    let records: Records?
}

// MARK: - Records
struct Records: Codable {
    let ipfsHTMLValue, cryptoETHAddress, whoisForSaleValue: String?
    let ipfsRedirectDomainValue: String?
    let cryptoMATICVersionERC20Address, cryptoMATICVersionMATICAddress: String?

    enum CodingKeys: String, CodingKey {
        case ipfsHTMLValue = "ipfs.html.value"
        case cryptoETHAddress = "crypto.ETH.address"
        case whoisForSaleValue = "whois.for_sale.value"
        case ipfsRedirectDomainValue = "ipfs.redirect_domain.value"
        case cryptoMATICVersionERC20Address = "crypto.MATIC.version.ERC20.address"
        case cryptoMATICVersionMATICAddress = "crypto.MATIC.version.MATIC.address"
    }
}
