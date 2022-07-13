//
//  BackendSocketService+Extension.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 7/5/22.
//

import Foundation

extension BackendSocketService {

    func emitPricesUpdate(_ tokenIds: [String]) {
        let city = SocketSendData(type: .priceUpdate, ids: tokenIds, data: "usd")

        if let encodedData = try? JSONEncoder().encode(city) {
            let jsonString = String(data: encodedData, encoding: .utf8)
            let msgString = URLSessionWebSocketTask.Message.string(jsonString ?? "no data")

            webSocketTask?.send(msgString) { error in
                if let error = error {
                    print("Failed with error \(error.localizedDescription)")
                } else {
                    // no-op
                    print("Sent socket price message!")
                }
            }
        } else {
            print("errorrr sendinggg")
        }
    }

}
