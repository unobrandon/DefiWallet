//
//  BackendSocketService.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 7/5/22.
//

import Foundation

struct SocketSendData: Codable {
    let type: SocketResponses
    let ids: [String]?
    let data: String?
}

struct SocketReceiveData: Codable {
    var type: SocketResponses
    var prices: [TokenPricesModel]?
}

class BackendSocketService: NSObject, URLSessionWebSocketDelegate {

    var wallet: WalletService
    var webSocketTask: URLSessionWebSocketTask?
    var walletPriceTimer: Timer?

    init(wallet: WalletService) {
        print("backend socket init")
        self.wallet = wallet
    }

    func connectSocket() {
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        let url = URL(string: Constants.backendWssBaseUrl)!

        webSocketTask = session.webSocketTask(with: url)
        if let webSocketTask = webSocketTask {
            webSocketTask.resume()
//            self.startWalletPriceTimer()
        }
    }

    func startWalletPriceTimer(_ ids: [String]) {
        self.walletPriceTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
            self.emitPricesUpdate(ids)
            print("emit Prices Update111: \(ids)")
        }
    }

    func closeSocket() {
        guard let webSocketTask = webSocketTask else { return }

        let reason = "Closing connection".data(using: .utf8)
        webSocketTask.cancel(with: .goingAway, reason: reason)

        self.wallet.networkStatus = .offline
        stopWalletPriceTimer()
    }

    private func stopWalletPriceTimer() {
        guard let timer = walletPriceTimer else { return }
        timer.invalidate()
    }

    func ping() {
        self.webSocketTask?.sendPing(pongReceiveHandler: { error in
            if let error = error {
                print("Error when sending PING \(error)")
                self.wallet.networkStatus = .offline
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

            case .failure(let error):
                print("Error when receiving \(error)")
            }

            self.receive()
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

            default:
                print("returned some other type")
            }

        } catch {
            print("error decoding data: \(error)")
        }
    }

    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("Web socket did connect")

        self.wallet.networkStatus = .connected
        self.ping()
        self.receive()
    }

    func urlSession(_ session: URLSession, taskIsWaitingForConnectivity task: URLSessionTask) {
        print("Web socket task Is Waiting For Connectivity.")
        self.wallet.networkStatus = .connecting
    }

    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("Web socket did disconnect. For reason: \(reason ?? Data())")
        closeSocket()
    }

}
