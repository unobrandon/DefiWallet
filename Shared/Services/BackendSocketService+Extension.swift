//
//  BackendSocketService+Extension.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 7/5/22.
//

import Foundation

extension BackendSocketService {

    func emitPricesUpdate(_ tokenIds: [String], currency: String) {
        let package = SocketSendData(type: .priceUpdate, ids: tokenIds, currency: nil, duration: nil, data: currency)

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

            let swap = SocketSendData(type: .swapQuote, ids: nil, currency: nil, duration: nil, data: jsonString ?? "")

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

    func emitMarketChartUpdate(currency: String, perPage: String, page: String) {
        let model = ["currency" : currency,
                     "perPage" : perPage,
                     "page": page]

        if let swapData = try? JSONEncoder().encode(model) {
            let jsonString = String(data: swapData, encoding: .utf8)

            let swap = SocketSendData(type: .marketCharts, ids: nil, currency: nil, duration: nil, data: jsonString ?? "")

            if let encodedData = try? JSONEncoder().encode(swap) {
                let jsonString = String(data: encodedData, encoding: .utf8)
                let msgString = URLSessionWebSocketTask.Message.string(jsonString ?? "no data")

                webSocketTask?.send(msgString) { error in
                    if let error = error {
                        print("Failed to emitMarketChartUpdate with error \(error.localizedDescription)")
                    }
                }
            }
        }
    }

    func emitTokenDetailPriceUpdate(externalId: String, currency: String) {
        let model = ["externalId" : externalId,
                     "currency": currency]

        if let swapData = try? JSONEncoder().encode(model) {
            let jsonString = String(data: swapData, encoding: .utf8)

            let swap = SocketSendData(type: .tokenPrice, ids: nil, currency: nil, duration: nil, data: jsonString ?? "")

            if let encodedData = try? JSONEncoder().encode(swap) {
                let jsonString = String(data: encodedData, encoding: .utf8)
                let msgString = URLSessionWebSocketTask.Message.string(jsonString ?? "no data")

                webSocketTask?.send(msgString) { error in
                    if let error = error {
                        print("Failed to emitMarketChartUpdate with error \(error.localizedDescription)")
                    }
                }
            }
        }
    }

    func emitPortfolioChartUpdate(currency: String, duration: String, jsonData: String) {
        let swap = SocketSendData(type: .portfolioChart, ids: nil, currency: currency, duration: duration, data: jsonData)

        if let encodedData = try? JSONEncoder().encode(swap) {
            let jsonString = String(data: encodedData, encoding: .utf8)
            let msgString = URLSessionWebSocketTask.Message.string(jsonString ?? "no data")

            webSocketTask?.send(msgString) { error in
                if let error = error {
                    print("Failed to emitMarketChartUpdate with error \(error.localizedDescription)")
                } else {
                    print("success emitting portfolio chart update!!!")
                }
            }
        }
    }

}
