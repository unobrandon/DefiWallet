//
//  WalletService+Other.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 8/31/22.
//

import SwiftUI

extension WalletService {

    func transactionImage(_ direction: Direction) -> String {
        switch direction {
        case .incoming:
            return "arrow.down"
        case .outgoing:
            return "paperplane.fill"
        case .exchange:
            return "arrow.left.arrow.right"
        }
    }

    func transactionDirectionImage(_ direction: TransactionDirection) -> String {
        switch direction {
        case .received:
            return "arrow.down"
        case .sent:
            return "paperplane.fill"
        case .swap:
            return "arrow.left.arrow.right"
        }
    }

    func transactionColor(_ direction: Direction) -> Color {
        switch direction {
        case .incoming:
            return Color.green
        case .outgoing:
            return Color.red
        case .exchange:
            return Color.blue
        }
    }

    func transactionDirectionColor(_ direction: TransactionDirection) -> Color {
        switch direction {
        case .received:
            return Color.green
        case .sent:
            return Color.red
        case .swap:
            return Color.blue
        }
    }

    func getNetworkImage(_ network: Network) -> Image {
        switch network {
        case .ethereum:
            return Image("eth_logo")
        case .polygon:
            return Image("polygon_logo")
        case .binanceSmartChain:
            return Image("binance_logo")
        case .avalanche:
            return Image("avalanche_logo")
        case .fantom:
            return Image("fantom_logo")
        }
    }

    func getNetworkTransactImage(_ network: String) -> Image {
        if network == "eth" {
            return Image("eth_logo")
        } else if network == "polygon" {
            return Image("polygon_logo")
        } else if network == "bsc" {
            return Image("binance_logo")
        } else if network == "avalanche" {
            return Image("avalanche_logo")
        } else if network == "fantom" {
            return Image("fantom_logo")
        } else {
            return Image("")
        }
    }

    func getNetworkColor(_ network: String) -> Color {
        if network == "eth" { return Color("ethereum")
        } else if network == "polygon" { return Color("polygon")
        } else if network == "bsc" { return Color("binance")
        } else if network == "avalanche" { return Color("avalanche")
        } else if network == "fantom" { return Color("fantom")
        } else { return Color.primary }
    }

    func getNetworkEnum(_ network: String) -> Network {
        if network == "eth" { return .ethereum
        } else if network == "polygon" { return .polygon
        } else if network == "bsc" { return .binanceSmartChain
        } else if network == "avalanche" { return .avalanche
        } else if network == "fantom" { return .fantom
        } else { return .ethereum }
    }

    func getNetworkNumber(_ network: String) -> String {
        if network == "eth" { return "1"
        } else if network == "polygon" { return "137"
        } else if network == "bsc" { return "56"
        } else if network == "avalanche" { return "43114"
        } else if network == "fantom" { return "250"
        } else { return "" }
    }

    func getChartDuration(_ timePeriod: String) -> String {
        if timePeriod == "h" { return "last hour"
        } else if timePeriod == "d" { return "last 24 hours"
        } else if timePeriod == "w" { return "last 7 days"
        } else if timePeriod == "m" { return "last 30 days"
        } else if timePeriod == "y" { return "last 12 months"
        } else { return "" }
    }

    func getBlockExplorerName(_ network: String) -> String {
        if network == "eth" {
            return "Etherscan.io"
        } else if network == "polygon" {
            return "Polygonscan.com"
        } else if network == "bsc" {
            return "Bscscan.com"
        } else if network == "avalanche" {
            return "Snowtrace.io"
        } else if network == "fantom" {
            return "Ftmscan.com"
        } else {
            return ""
        }
    }

    func getScannerUrl(_ network: String) -> String {
        if network == "eth" {
            return "https://etherscan.io/tx/"
        } else if network == "polygon" {
            return "https://polygonscan.com/tx/"
        } else if network == "bsc" {
            return "https://www.bscscan.com/tx/"
        } else if network == "avalanche" {
            return "https://snowtrace.io/tx/"
        } else if network == "fantom" {
            return "https://ftmscan.com/tx/"
        } else {
            return ""
        }
    }

    // Remove this. Not good logic.
    func getNetworkTotal(_ completeBalance: CompleteBalance) -> Double? {
        if completeBalance.network == "eth" {
            return accountPortfolio?.ethereumAssetsValue
        } else if completeBalance.network == "bsc" {
            return accountPortfolio?.bscAssetsValue
        } else if completeBalance.network == "polygon" {
            return accountPortfolio?.polygonAssetsValue
        } else if completeBalance.network == "avalanche" {
            return accountPortfolio?.avalancheAssetsValue
        } else if completeBalance.network == "fantom" {
            return accountPortfolio?.fantomAssetsValue
        } else if completeBalance.network == "solana" {
            return accountPortfolio?.solanaAssetsValue
        } else {
            return 0.00
        }
    }

}
