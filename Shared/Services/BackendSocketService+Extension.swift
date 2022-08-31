//
//  BackendSocketService+Extension.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 7/5/22.
//

import Foundation

extension BackendSocketService {

    func emitPricesUpdate(_ tokenIds: [String]) {
        let package = SocketSendData(type: .priceUpdate, ids: tokenIds, data: "usd")

        if let encodedData = try? JSONEncoder().encode(package) {
            let jsonString = String(data: encodedData, encoding: .utf8)
            let msgString = URLSessionWebSocketTask.Message.string(jsonString ?? "no data")

            webSocketTask?.send(msgString) { error in
                if let error = error {
                    print("Failed to emitPricesUpdate with error \(error.localizedDescription)")
                }
            }
        } else {
            print("errorrr sendinggg emitPricesUpdate func")
        }
    }

    func emitSwapQuoteUpdate(network: String, fromTokenAddress: String, toTokenAddress: String,
                             signingAddress: String, amount: String, slippage: String) {
        let model = ["network" : network,
                     "fromTokenAddress" : fromTokenAddress,
                     "toTokenAddress": toTokenAddress,
                     "signingAddress": signingAddress,
                     "amount": amount,
                     "slippage": slippage]

        if let swapData = try? JSONEncoder().encode(model) {
            let jsonString = String(data: swapData, encoding: .utf8)

            let swap = SocketSendData(type: .swapQuote, ids: nil, data: jsonString ?? "")

            if let encodedData = try? JSONEncoder().encode(swap) {
                let jsonString = String(data: encodedData, encoding: .utf8)
                let msgString = URLSessionWebSocketTask.Message.string(jsonString ?? "no data")

                webSocketTask?.send(msgString) { error in
                    if let error = error {
                        print("Failed to emitSwapQuoteUpdate with error \(error.localizedDescription)")
                    }
                }
            }
        }
    }

}
