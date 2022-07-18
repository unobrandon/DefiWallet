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
    static let infuraBaseWssUrl = "wss://mainnet.infura.io/ws/v3/"
    static let zapperBaseUrl = "https://api.zapper.fi/v1/"
    static let zerionWssUrl = "wss://api-v4.zerion.io"
    static let walletConnectMetadataIcon = "https://ucarecdn.com/12bb9755-e63c-46ad-b118-3a44703a5d8f/C1F62A2EBB0145DA9D837855713C5A93.jpeg"
    // "https://iconstore.co/assets/img/set/cover/zodiac-signs-cover.png"

    static let iPadMaxWidth: CGFloat = 640
    static let generateWalletDelay = 5.0

    static let eighteenDecimal: Double = 1000000000000000000

    static var currencyCircleImage: String {
        return "dollarsign.circle"
    }
    static var currencySquareImage: String {
        return "dollarsign.square"
    }

    // MARK: General

    enum DeviceType {
        case ios
        case mac
        case macCatalyst
        case unknown
    }

    static var projectName: String {
        #if targetEnvironment(macCatalyst)
        return MacConstants.appName
        #elseif os(macOS)
        return MacConstants.appName
        #elseif os(iOS)
        return MobileConstants.appName
        #endif
    }

    static var projectVersion: String {
        #if targetEnvironment(macCatalyst)
        return MacConstants.appVersion
        #elseif os(macOS)
        return MacConstants.appVersion
        #elseif os(iOS)
        return MobileConstants.appVersion
        #endif
    }

    static var device: DeviceType {
        #if targetEnvironment(macCatalyst)
        return .macCatalyst
        #elseif os(macOS)
        return .mac
        #elseif os(iOS)
        return .ios
        #endif
    }

    // MARK: Keys

    static var backendBaseUrl: String {
        guard let url = Bundle.main.infoDictionary?["BACKEND_URL"] as? String else { return "" }
        return "https://" + url
    }

    static var zapperApiKey: String {
        guard let key = Bundle.main.infoDictionary?["ZAPPER_API_KEY"] as? String else { return "api_key=" }
        return "api_key=" + key
    }
    static var infuraProjectId: String {
        return Bundle.main.infoDictionary?["INFURA_PROJECT_ID"] as? String ?? ""
    }
    static var infuraProjectSecret: String {
        return Bundle.main.infoDictionary?["INFURA_PROJECT_SECRET"] as? String ?? ""
    }
    static var walletConnectProjectId: String {
        return Bundle.main.infoDictionary?["WALLET_CONNECT_PROJECT_ID"] as? String ?? ""
    }
    static var zerionApiKey: String {
        return Bundle.main.infoDictionary?["ZERION_API_KEY"] as? String ?? ""
    }

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

    // MARK: Get Any Value

    public func getConfigValue(forKey key: String) -> String {
        return Bundle.main.infoDictionary?[key] as? String ?? ""
    }

}
