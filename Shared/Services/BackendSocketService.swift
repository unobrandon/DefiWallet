//
//  BackendSocketService.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 7/5/22.
//

import Foundation
import SwiftUI

struct SocketSendData: Codable {
    let type: SocketResponses
    let ids: [String]?
    let data: String?
}

struct SocketReceiveData: Codable {
    var type: SocketResponses?
    var prices: [TokenPricesModel]?
    var swapResult: SwapTokens?
    var marketChart: [TokenDetails]?
}

class BackendSocketService: NSObject, URLSessionWebSocketDelegate {

    var wallet: WalletService
    var market: MarketsService
    var webSocketTask: URLSessionWebSocketTask?
    var disconnectedTimer: Timer?
    var walletPriceTimer: Timer?
    var marketCapTimer: Timer?
    private let disconnectedInterval: Double = 5
    private let marketCapInterval: Double = 10

    init(wallet: WalletService, market: MarketsService) {
        print("backend socket init")
        self.wallet = wallet
        self.market = market
    }

    func connectSocket() {
        print("called connect sockettt")
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        guard let url = URL(string: Constants.backendWssBaseUrl) else { return }

        webSocketTask = nil
        webSocketTask = session.webSocketTask(with: url)
        if let webSocketTask = webSocketTask {
            webSocketTask.resume()
        }
    }

    func closeSocket() {
        guard let webSocketTask = webSocketTask else { return }

        let reason = "Closing connection".data(using: .utf8)
        webSocketTask.cancel(with: .goingAway, reason: reason)

        DispatchQueue.main.async {
            self.wallet.networkStatus = .offline
        }

        stopWalletPriceTimer()
        stopMarketCapTimer()
    }

    private func stopDisconnectedTimer() {
        guard let timer = disconnectedTimer else { return }
        timer.invalidate()
        disconnectedTimer = nil
    }

    private func stopWalletPriceTimer() {
        guard let timer = walletPriceTimer else { return }
        timer.invalidate()
    }

    func stopMarketCapTimer() {
        guard let timer = marketCapTimer else { return }
        timer.invalidate()
    }

    func startDisconnectedTimer() {
        self.closeSocket()

        self.disconnectedTimer = Timer.scheduledTimer(withTimeInterval: disconnectedInterval, repeats: true) { _ in
            self.connectSocket()
        }
    }

    func startMarketCapTimer(currency: String) {
        self.marketCapTimer = Timer.scheduledTimer(withTimeInterval: marketCapInterval, repeats: true) { _ in
            self.emitMarketChartUpdate(currency: currency, perPage: "10", page: "1")
        }
    }

    func ping() {
        self.webSocketTask?.sendPing(pongReceiveHandler: { error in
            if let error = error {
                print("Error when sending PING \(error)")
                DispatchQueue.main.async {
                    self.wallet.networkStatus = .offline

                    if self.disconnectedTimer == nil {
                        self.startDisconnectedTimer()
                    }
                }
            } else {
                DispatchQueue.global().asyncAfter(deadline: .now() + 5) {
                    self.ping()
                }
            }
        })
    }

    func receive() {
        self.webSocketTask?.receive { result in
            switch result {
            case .success(let message):
                switch message {
                case .data(let data):
                    self.handle(data)
                case .string(let text):
                    guard let data = text.data(using: .utf8) else { return }
                    self.handle(data)
                }

                self.receive()
            case .failure(let error):
                print("Error when receiving \(error.asAFError?.responseCode ?? 0)")
            }
        }
    }

    func handle(_ data: Data) {
        let decoder = JSONDecoder()
        do {
            let receiveData = try decoder.decode(SocketReceiveData.self, from: data)
            switch receiveData.type {
            case .priceUpdate:
                guard let prices = receiveData.prices else { return }
                self.wallet.updateAccountBalancePrices(prices)

            case .swapQuote:
                guard let swap = receiveData.swapResult else { return }
                DispatchQueue.main.async {
                    print("did receive a new swap result: \(swap.transaction?.gas ?? 0)")
                    self.wallet.swapResult = swap
                }

            case .marketCharts:
                guard let chart = receiveData.marketChart else { return }
                DispatchQueue.main.async {
                    print("did receive marketChart result: \(chart.count)")
                    self.market.coinsByMarketCap = chart
                    if let storage = StorageService.shared.marketCapStorage {
                        storage.async.setObject(chart, forKey: "marketCapList") { _ in }
                    }
                }

            default:
                print("returned some other type")
            }

        } catch {
            print("error decoding data: \(error)")
        }
    }

    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("\(Constants.projectName) backend web socket did connect!")

        DispatchQueue.main.async {
            self.wallet.networkStatus = .connected
        }

        self.ping()
        self.receive()
        self.stopDisconnectedTimer()
    }

    func urlSession(_ session: URLSession, taskIsWaitingForConnectivity task: URLSessionTask) {
        print("Web socket task Is Waiting For Connectivity.")
        DispatchQueue.main.async {
            self.wallet.networkStatus = self.disconnectedTimer != nil ? .reconnecting : .connecting
            self.stopDisconnectedTimer()
        }
    }

    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("Web socket did disconnect. For reason: \(reason ?? Data())")
        if disconnectedTimer == nil {
            DispatchQueue.main.async {
                self.startDisconnectedTimer()
            }
        }
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError: Error?) {
        print("Web socket did disconnect!! on the didCompleteWithError")
        if disconnectedTimer == nil {
            DispatchQueue.main.async {
                self.startDisconnectedTimer()
            }
        }
    }

}
