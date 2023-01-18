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
    let currency: String?
    let duration: String?
    let data: String?
}

struct SocketReceiveData: Codable {
    var type: SocketResponses?
    var prices: [TokenPricesModel]?
    var swapResult: SwapTokens?
    var marketChart: [TokenDetails]?
    var tokenChart: [[Double]]?
    var tokenPrice: Double?
}

class BackendSocketService: NSObject, URLSessionWebSocketDelegate {

    var wallet: WalletService
    var market: MarketsService
    var webSocketTask: URLSessionWebSocketTask?
    var disconnectedTimer: Timer?
    var walletPriceTimer: Timer?
    var marketCapTimer: Timer?
    var tokenDetailPriceTimer: Timer?
    private let disconnectedInterval: Double = 5
    private let walletPriceInterval: Double = 5
    private let marketCapInterval: Double = 10
    private let tokenDetailPriceInterval: Double = 10

    init(wallet: WalletService, market: MarketsService) {
        print("backend socket init")
        self.wallet = wallet
        self.market = market
    }

    func connectSocket() {
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        guard let url = URL(string: Constants.backendWssBaseUrl + "?id=" + wallet.currentUser.address) else { return }

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
        stopTokenDetailPriceTimer()
    }

    private func stopDisconnectedTimer() {
        guard let timer = disconnectedTimer else { return }
        timer.invalidate()
        disconnectedTimer = nil
    }

    func stopWalletPriceTimer() {
        guard let timer = walletPriceTimer else { return }
        timer.invalidate()
        walletPriceTimer = nil
    }

    func stopMarketCapTimer() {
        guard let timer = marketCapTimer else { return }
        timer.invalidate()
        marketCapTimer = nil
    }

    func stopTokenDetailPriceTimer() {
        guard let timer = tokenDetailPriceTimer else { return }
        timer.invalidate()
        tokenDetailPriceTimer = nil
    }

    func startDisconnectedTimer() {
        self.closeSocket()

        self.disconnectedTimer = Timer.scheduledTimer(withTimeInterval: disconnectedInterval, repeats: true) { _ in
            self.connectSocket()
        }
    }

    func startWalletPriceTimer(_ tokenIds: [String], currency: String) {
        self.walletPriceTimer = Timer.scheduledTimer(withTimeInterval: walletPriceInterval, repeats: true) { _ in
            self.emitPricesUpdate(tokenIds, currency: currency)
            // Emit Zerion chart account request
            self.wallet.emitAccountRequest(UserDefaults.standard.string(forKey: "chartType") ?? self.wallet.chartType)
        }
    }

    func startMarketCapTimer(currency: String) {
        self.marketCapTimer = Timer.scheduledTimer(withTimeInterval: marketCapInterval, repeats: true) { _ in
            self.emitMarketChartUpdate(currency: currency, perPage: "10", page: "1")
        }
    }

    func startTokenDetailPriceTimer(externalId: String, currency: String) {
        // First initial call to get price
        self.emitTokenDetailPriceUpdate(externalId: externalId, currency: currency)

        self.tokenDetailPriceTimer = Timer.scheduledTimer(withTimeInterval: tokenDetailPriceInterval, repeats: true) { _ in
            self.emitTokenDetailPriceUpdate(externalId: externalId, currency: currency)
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

            case .tokenChart:
                guard let chart = receiveData.tokenChart else { return }
                DispatchQueue.main.async {
                    print("did receive token detail result: \(chart.last?.last ?? 0)")
                    self.wallet.tokenDetailChart = chart
                }

            case .tokenPrice:
                guard let price = receiveData.tokenPrice else { return }
                DispatchQueue.main.async {
                    print("did receive token detail price result: \(price)")
                    self.wallet.tokenDetailPrice = price
                }

            case .transaction:
                print("we received a TRANSACTION!!!")

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
