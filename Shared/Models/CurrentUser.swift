//
//  CurrentUser.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/13/22.
//

import Foundation

struct CurrentUser: Codable, Equatable {

    let objectId: String?
    let sessionToken: String
    let address: String
    let mediumAddress: String
    let shortAddress: String
    let secretPhrase: [String]
    let password: String
    let username: String?
    let avatar: String?
    let miniAvatar: String?
    let currency: String
    let createdAt: String
    let updatedAt: String
    let wallet: Wallet

}

struct CreateNewUser: Codable, Equatable {
	
	let token: String

}

struct RegisteredUser: Codable, Equatable {

    let objectId: String
    let username: String
    let ethAddress: String
    let accounts: [String]
    let createdAt: String
    let currency: String
    let sessionToken: String
    let updatedAt: String

}

struct AuthRequestMsg: Codable, Equatable {
	let id: String
	let message: String
	let profileId: String

}

struct AuthVerifyMsg: Decodable, Equatable, Encodable {
	let id: String?
	let domain: String?
	let chainId: Int?
	let address: String?
	let statement: String?
	let uri: String?
	let expirationTime: String?
	let notBefore: String?
	let version: String?
	let nonce: String?
	let profileId: String?
	let status: String?
	let message: String?
	let data: Data?
	let token: String?

}

struct AuthWalletRequest: Codable {
	let payload: AuthWalletRequestPayload?
}

struct AuthWalletRequestPayload: Codable {
	let type: String?
	let domain: String?
	let address: String?
	let statement: String?
	let version, chainID, nonce, issuedAt: String?
	let expirationTime, invalidBefore: String?
	
	enum CodingKeys: String, CodingKey {
		case type, domain, address, statement, version
		case chainID = "chain_id"
		case nonce
		case issuedAt = "issued_at"
		case expirationTime = "expiration_time"
		case invalidBefore = "invalid_before"
	}
}


