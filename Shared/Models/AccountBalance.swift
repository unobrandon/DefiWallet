//
//  AccountBalance.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/15/22.
//
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let accountBalance = try? newJSONDecoder().decode(AccountBalance.self, from: jsonData)

//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseAccountBalance { response in
//     if let accountBalance = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

// MARK: - AccountBalance
struct AccountBalance: Codable {
    let deposits, debt, vesting: Claimable?
    let wallet: [String: WalletBalance]?
    let claimable, locked: Claimable?
}

//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseClaimable { response in
//     if let claimable = response.result.value {
//       ...
//     }
//   }

// MARK: - Claimable
struct Claimable: Codable {
}

//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseWallet { response in
//     if let wallet = response.result.value {
//       ...
//     }
//   }

// MARK: - Wallet
struct WalletBalance: Codable {
    let appID, address, network: String?
    let balanceUSD: Double?
    let metaType: String?
    let displayProps: DisplayProps?
    let type, contractType: String?
    let context: Context?
    let breakdown: [String]?

    enum CodingKeys: String, CodingKey {
        case appID = "appId"
        case address, network, balanceUSD, metaType, displayProps, type, contractType, context, breakdown
    }
}

//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseContext { response in
//     if let context = response.result.value {
//       ...
//     }
//   }

// MARK: - Context
struct Context: Codable {
    let symbol: String?
    let balance: Double?
    let decimals: Int?
    let balanceRaw: String?
    let price: Double?
}

//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseDisplayProps { response in
//     if let displayProps = response.result.value {
//       ...
//     }
//   }

// MARK: - DisplayProps
struct DisplayProps: Codable {
    let label: String?
    let secondaryLabel: String?
    let images: [String]?
    let stats: [String]?
}
