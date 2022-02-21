//
//  Wallet.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/15/22.
//

import Foundation

struct Wallet: Codable, Equatable {
    let address: String
    let data: Data
    let name: String
    let isHD: Bool
}

struct HDKey {
    let name: String?
    let address: String
}

enum SeedStrength {
    case twelveWords
    case twentyFourWords
}
