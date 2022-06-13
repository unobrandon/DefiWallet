//
//  WalletService+AddressSocket.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 4/14/22.
//

import Foundation
import SocketIO
import SwiftUI

extension WalletService {

    func connectAccountData() {
        addressSocket.connect(withPayload: ["address": currentUser.address, "currency": currentUser.currency])

        addressSocket.on(clientEvent: .connect) { _, _ in
            self.setSockets()
            self.emitAccountRequest()
            self.networkStatus = .connected
        }

        addressSocket.on(clientEvent: .disconnect) { _, _ in
            self.stopAccountTimer()
            self.networkStatus = .offline
        }

        addressSocket.on(clientEvent: .reconnect) { _, _ in
            self.networkStatus = .reconnecting
        }
    }

    func disconnectAccountSocket() {
        addressSocket.disconnect()
        addressSocket.removeAllHandlers()
    }

    func stopAccountTimer() {
        guard let timer = accountSocketTimer else { return }
        timer.invalidate()
    }

    func startAccountTimer() {
        self.accountSocketTimer = Timer.scheduledTimer(withTimeInterval: portfolioRefreshInterval, repeats: true) { _ in
            self.emitAccountRequest()
        }
    }

    func emitAccountRequest() {
        self.addressSocket.emit("get", ["scope": ["portfolio", "charts", "staked-assets"],
                                        "payload": ["address": self.currentUser.address, "currency": self.currentUser.currency, "charts_type": UserDefaults.standard.string(forKey: "chartType") ?? self.chartType]])
    }

    func setSockets() {
        self.addressSocket.on("received address portfolio") { data, _ in
            DispatchQueue.main.async {
                guard let array = data as? [[String: AnyObject]],
                      let firstDict = array.first,
                      let payload = firstDict["payload"],
                      let assets = payload["portfolio"] as? [String: AnyObject] else { return }

                let absoluteChange24h = assets["absolute_change_24h"] as? Double
                let arbitrumAssetsValue = assets["arbitrum_assets_value"] as? Double
                let assetsValue = assets["assets_value"] as? Double
                let auroraAssetsValue = assets["aurora_assets_value"] as? Double
                let avalancheAssetsValue = assets["avalanche_assets_value"] as? Double
                let borrowedValue = assets["borrowed_value"] as? Double
                let bscAssetsValue = assets["bsc_assets_value"] as? Double
                let depositedValue = assets["deposited_value"] as? Double
                let ethereumAssetsValue = assets["ethereum_assets_value"] as? Double
                let fantomAssetsValue = assets["fantom_assets_value"] as? Double
                let lockedValue = assets["locked_value"] as? Double
                let loopringAssetsValue = assets["loopring_assets_value"] as? Double
                let nftFloorPriceValue = assets["nft_floor_price_value"] as? Double
                let nftLastPriceValue = assets["nft_last_price_value"] as? Double
                let optimismAssetsValue = assets["optimism_assets_value"] as? Double
                let polygonAssetsValue = assets["polygon_assets_value"] as? Double
                let relativeChange24h = assets["relative_change_24h"] as? Double
                let solanaAssetsValue = assets["solana_assets_value"] as? Double
                let stakedValue = assets["staked_value"] as? Double
                let totalValue = assets["total_value"] as? Double
                let xdaiAssetsValue = assets["xdai_assets_value"] as? Double

                let portfolio = AccountPortfolio(arbitrumAssetsValue: arbitrumAssetsValue,
                                                         assetsValue: assetsValue,
                                                         auroraAssetsValue: auroraAssetsValue,
                                                         avalancheAssetsValue: avalancheAssetsValue,
                                                         borrowedValue: borrowedValue,
                                                         bscAssetsValue: bscAssetsValue,
                                                         depositedValue: depositedValue,
                                                         ethereumAssetsValue: ethereumAssetsValue,
                                                         fantomAssetsValue: fantomAssetsValue,
                                                         lockedValue: lockedValue,
                                                         loopringAssetsValue: loopringAssetsValue,
                                                         nftFloorPriceValue: nftFloorPriceValue,
                                                         nftLastPriceValue: nftLastPriceValue,
                                                         optimismAssetsValue: optimismAssetsValue,
                                                         polygonAssetsValue: polygonAssetsValue,
                                                         solanaAssetsValue: solanaAssetsValue,
                                                         stakedValue: stakedValue,
                                                         totalValue: totalValue,
                                                         xdaiAssetsValue: xdaiAssetsValue,
                                                         absoluteChange24h: absoluteChange24h,
                                                         relativeChange24h: relativeChange24h)

                self.accountPortfolio = portfolio

                if let storage = StorageService.shared.portfolioStorage {
                    storage.async.setObject(portfolio, forKey: "portfolio") { _ in }
                }

                print("the account value is: \(String(describing: totalValue)) & now: \(String(describing: self.accountPortfolio?.relativeChange24h))")
            }
        }

        self.addressSocket.on("received address charts") { data, _ in
            DispatchQueue.main.async {
                guard let array = data as? [[String: AnyObject]],
                      let firstDict = array.first,
                      let payload = firstDict["payload"],
                      let charts = payload["charts"] as? [String : AnyObject] else { return }

                self.accountChart.removeAll()

                for main in charts {
                    if let loopData = main.value as? [AnyObject] {
                        for chartTuple in loopData {
                            let tupleMirror = Mirror(reflecting: chartTuple)
                            let tupleElements = tupleMirror.children.map({ $0.value })

                            if let time = tupleElements.first as? Int,
                               let value = tupleElements.last as? Double {
                                self.accountChart.insert(ChartValue(timestamp: time, amount: value), at: 0)
                            }
                        }
                    }
                }

                if !self.accountChart.isEmpty, let storage = StorageService.shared.chartStorage {
                    let type = UserDefaults.standard.string(forKey: "chartType") ?? self.chartType
                    storage.async.setObject(self.accountChart, forKey: "portfolioChart\(type)") { _ in }
                }
            }
        }

        self.addressSocket.on("received address transactions") { data, _ in
            DispatchQueue.main.async {
                guard let array = data as? [[String: AnyObject]],
                      let firstDict = array.first,
                      let payload = firstDict["payload"] else { return }

//                print("the transactions value is: \(payload)")
            }
        }

        self.addressSocket.on("received address polygon-assets") { data, _ in
            DispatchQueue.main.async {
                guard let array = data as? [[String: AnyObject]],
                      let firstDict = array.first,
                      let payload = firstDict["payload"],
                      let assets = payload["polygon-assets"] as? [String: AnyObject] else { return }

//                print("the polygon-assets value is: \(assets)")
            }
        }

        self.addressSocket.on("received address staked-assets") { data, _ in
            DispatchQueue.main.async {
                guard let array = data as? [[String: AnyObject]],
                      let firstDict = array.first,
                      let payload = firstDict["payload"] else { return }

                print("the staked-assets value is: \(payload)")
            }
        }

    }

    func emitSingleChartRequest(_ type: String? = "d") {
        self.chartType = type ?? "d"
        UserDefaults.standard.setValue(self.chartType, forKey: "chartType")

        #if os(iOS)
            HapticFeedback.rigidHapticFeedback()
        #endif

        if let storage = StorageService.shared.chartStorage {
            storage.async.object(forKey: "portfolioChart\(self.chartType)") { result in
                switch result {
                case .value(let chart):
                    DispatchQueue.main.async {
                        self.accountChart = chart
                    }
                case .error(let error):
                    print("error getting local chart: \(error.localizedDescription)")
                }
            }
        }

        self.addressSocket.emit("get", ["scope": ["charts"], "payload": ["address": self.currentUser.address, "currency": self.currentUser.currency, "charts_type": type ?? chartType]])
    }

}
