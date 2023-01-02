//
//  MarketsService+Socket.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 6/7/22.
//

import Foundation

extension MarketsService {

    func connectGasSocket() {
        gasSocket.connect()

        gasSocket.on(clientEvent: .connect) { _, _ in
            self.setGasSocket()
        }

        gasSocket.on(clientEvent: .disconnect) { _, _ in
            self.stopGasTimer()
        }
    }

    private func disconnectGasSocket() {
        gasSocket.disconnect()
        gasSocket.removeAllHandlers()
    }

    func stopGasTimer() {
        guard let timer = gasSocketTimer else { return }
        timer.invalidate()
    }

    func startGasTimer() {
        self.gasSocketTimer = Timer.scheduledTimer(withTimeInterval: gasRefreshInterval, repeats: true) { _ in
            self.emitGasRequest()
        }
    }

    private func emitGasRequest() {
        self.gasSocket.emit("get", ["scope": ["price"], "payload": ["body parameter": "value"]])
    }

    private func setGasSocket() {
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

}
