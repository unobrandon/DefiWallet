//
//  WalletService+AddressSocket.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 4/14/22.
//

import Foundation
import SocketIO

extension WalletService {

    func connectAccountData() {
        if let storage = StorageService.shared.portfolioStorage {
            storage.async.object(forKey: "portfolio") { result in
                switch result {
                case .value(let portfolio):
                    DispatchQueue.main.async {
                        self.accountPortfolio = portfolio
                    }
                case .error(let error):
                    print("error getting local portfolio: \(error.localizedDescription)")
                }
            }
        }

        addressSocket.connect(withPayload: ["address": currentUser.address, "currency": currentUser.currency])

        addressSocket.on(clientEvent: .connect) { _, _ in
            self.loadAddressRequest()
            self.emitChartRequest()
            self.emitPortfolioRequest()
            self.networkStatus = .connected
        }

        addressSocket.on(clientEvent: .disconnect) { _, _ in
            self.stopChartTimer()
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

    func stopChartTimer() {
        guard let timer = chartSocketTimer else { return }
        timer.invalidate()
    }

    func loadAddressRequest() {
        let topics = ["assets", "transactions"]

        addressSocket.emit("get", ["scope": topics, "payload": ["address": currentUser.address, "currency": currentUser.currency]])

        self.addressSocket.on("received address portfolio") { data, _ in
            DispatchQueue.main.async {
                guard let array = data as? [[String: AnyObject]],
                      let firstDict = array.first,
                      let payload = firstDict["payload"],
                      let assets = payload["portfolio"] as? [String: AnyObject] else { return }

                let absoluteChange24h = assets["absolute_change_24h"] as? String
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
                let relativeChange24h = assets["relative_change_24h"] as? String
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

                print("the account value is: \(String(describing: totalValue)) & now: \(String(describing: self.accountPortfolio?.totalValue))")
            }
        }

        self.addressSocket.on("received address charts") { data, _ in
            DispatchQueue.main.async {
                guard let array = data as? [[String: AnyObject]],
                      let firstDict = array.first,
                      let payload = firstDict["payload"],
                      let charts = payload["charts"] as? [String : AnyObject] else { return }

                self.accountChart = charts["others"] as? [String : Double]
                print("the chart new is: \(String(describing: charts["others"])) &&more \(self.accountChart)")
            }
        }

        self.addressSocket.on("received address transactions") { data, _ in
            DispatchQueue.main.async {
                guard let array = data as? [[String: AnyObject]],
                      let firstDict = array.first,
                      let payload = firstDict["payload"],
                      let assets = payload["transactions"] as? [String: AnyObject] else { return }

                print("the transactions value is: \(assets)")
            }
        }
    }

    func emitChartRequest() {
        self.chartSocketTimer = Timer.scheduledTimer(withTimeInterval: chartRefreshInterval, repeats: false) { _ in
            self.addressSocket.emit("get", ["scope": ["charts"], "payload": ["address": self.currentUser.address, "currency": self.currentUser.currency]])
        }
    }

    func emitPortfolioRequest() {
        self.chartSocketTimer = Timer.scheduledTimer(withTimeInterval: portfolioRefreshInterval, repeats: true) { _ in
            self.addressSocket.emit("get", ["scope": ["portfolio"], "payload": ["address": self.currentUser.address, "currency": self.currentUser.currency]])
        }
    }

}
