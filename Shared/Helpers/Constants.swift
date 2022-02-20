//
//  Constants.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/12/22.
//

import SwiftUI

public struct Constants {
    // Made for both iOS and macOS

    static let moralisBaseWssUrl = "wss://speedy-nodes-nyc.moralis.io/"
    static let zapperBaseUrl = "https://api.zapper.fi/v1/"

    // MARK: Universal
    static let zapperApiKey = "api_key=96e0cc51-a62e-42ca-acee-910ea7d2a241"

    // MARK: Ethereum
    static var ethNodeWssUrl: String {
        return Bundle.main.infoDictionary?["ETH_NODE_WWS_URL"] as? String ?? ""
    }

    // MARK: Polygon
    static var polygonNodeWssUrl: String {
        return Bundle.main.infoDictionary?["POLYGON_NODE_WWS_URL"] as? String ?? ""
    }

    // MARK: Binance
    static var binanceNodeWssUrl: String {
        return Bundle.main.infoDictionary?["BSC_NODE_WWS_URL"] as? String ?? ""
    }

    // MARK: Avalanche
    static var avaxNodeWssUrl: String {
        return Bundle.main.infoDictionary?["AVAX_NODE_WWS_URL"] as? String ?? ""
    }

    // MARK: Public functions

    public func getConfigValue(forKey key: String) -> String {
        return Bundle.main.infoDictionary?[key] as? String ?? ""
    }

}
