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
        self.addressSocket.connect(withPayload: ["address": currentUser.address, "currency": currentUser.currency])
        self.setSockets()

        addressSocket.on(clientEvent: .connect) { _, _ in
            self.emitAccountRequest(UserDefaults.standard.string(forKey: "chartType"))
        }

//        addressSocket.on(clientEvent: .disconnect) { _, _ in
//        }
//        addressSocket.on(clientEvent: .reconnect) { _, _ in
//            self.networkStatus = .reconnecting
//        }
    }

    func disconnectAccountSocket() {
        addressSocket.disconnect()
        addressSocket.removeAllHandlers()
    }

    func emitAccountRequest(_ type: String? = "d") {
        self.addressSocket.emit("get", ["scope": ["charts"],
                                        "payload": ["address": self.currentUser.address, "currency": self.currentUser.currency, "charts_type": type]])
    }

    func setSockets() {
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

                self.isLoadingPortfolioChart = false

                if !self.accountChart.isEmpty, let storage = StorageService.shared.chartStorage {
                    let type = UserDefaults.standard.string(forKey: "chartType") ?? self.chartType
                    storage.async.setObject(self.accountChart, forKey: "portfolioChart\(type)") { _ in }
                }
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
