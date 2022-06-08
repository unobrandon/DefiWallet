//
//  MarketsService+Socket.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 6/7/22.
//

import Foundation

extension MarketsService {

    func connectSockets() {
        gasSocket.connect()
        assetSocket.connect()

        gasSocket.on(clientEvent: .connect) { _, _ in
            self.fetchGasSocket()
        }

        gasSocket.on(clientEvent: .disconnect) { _, _ in
            self.stopGasTimer()
        }

        assetSocket.on(clientEvent: .connect) { _, _ in
            self.fetchAssetsSocket()
        }
    }

    private func disconnectAccountSocket() {
        gasSocket.disconnect()
        gasSocket.removeAllHandlers()
    }

    func stopGasTimer() {
        guard let timer = gasSocketTimer else { return }
        timer.invalidate()
    }

    private func fetchGasSocket() {

        self.gasSocketTimer = Timer.scheduledTimer(withTimeInterval: gasRefreshInterval, repeats: true) { _ in
            self.gasSocket.emit("get", ["scope": ["price"], "payload": ["body parameter": "value"]])
        }

        gasSocket.on("received gas price") { data, _ in
            guard let array = data as? [[String: AnyObject]],
                  let firstDict = array.first,
                  let payload = firstDict["payload"],
                  let prices = payload["price"] as? [String: AnyObject] else { return }

            guard let source = prices["source"] as? String,
                  let datetime = prices["datetime"] as? String,
                  let fast = prices["fast"] as? Double,
                  let standard = prices["standard"] as? Double,
                  let slow = prices["slow"] as? Double else { return }

            print("the standard gas is: \(standard)")
            DispatchQueue.main.async {
                self.gasSocketPrices = GasSocketPrice(source: source, datetime: datetime, rapid: prices["rapid"] as? Double, fast: fast, standard: standard, slow: slow)
            }
        }
    }

    private func fetchAssetsSocket() {

        assetSocket.on("received assets categories") { data, _ in
            DispatchQueue.main.async {
                if let array = data as? [[String: AnyObject]], let firstDict = array.first {
                    let asset = firstDict["payload"] as? [String: AnyObject]
                    print("received assets categories value is: \(String(describing: asset))")
                }
            }
        }

        assetSocket.on("received assets full-info") { data, _ in
            guard let array = data as? [[String: AnyObject]],
                  let firstDict = array.first,
                  let payload = firstDict["payload"] as? [String: AnyObject],
                  let fullInfo = payload["full-info"] as? [String: AnyObject],
                  let asset = fullInfo["asset"] as? [String: AnyObject] else { return }

//            guard let assetCode = asset["asset_code"] as? String,
//                  let decimals = asset["decimals"] as? Int,
//                  let iconUrl = asset["icon_url"] as? String,
//                  let isDisplayable = asset["is_displayable"] as? Int,
//                  let isVerified = asset["is_verified"] as? Int,
//                  let tokenName = asset["name"] as? String,
//                  let symbol = asset["symbol"] as? String,
//                  let circulatingSupply = payload["circulating_supply"] as? Double,
//                  let description = payload["description"] as? String else { return }

            DispatchQueue.main.async {
//                if let array = data as? [[String: AnyObject]], let firstDict = array.first {
//                    let payloaddd = firstDict["payload"]! as! [String: AnyObject]
                print("that payload: \(asset)! && received assets full-info value is: \(String(describing: asset["name"])) \n\(fullInfo)")
//                }
            }
        }

    }

    func emitFullInfoAssetSocket(_ assetCode: String, currency: String) {
        assetSocket.emit("get", ["scope": ["full-info"], "payload": ["asset_code": assetCode, "currency": currency]])
        print("sent the emit \(assetCode)")
    }

}
