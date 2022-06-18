//
//  WalletService+CompoundSocket.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 6/17/22.
//

import Foundation
import SocketIO
import SwiftUI

extension WalletService {

    func connectCompoundData() {
        compoundSocket.connect(withPayload: ["address": currentUser.address, "currency": currentUser.currency])

        compoundSocket.on(clientEvent: .connect) { _, _ in
            self.setCompoundSockets()
//            self.emitCompoundRequest()
        }

        compoundSocket.on(clientEvent: .disconnect) { _, _ in
            self.stopCompoundTimer()
        }

        compoundSocket.on(clientEvent: .reconnect) { _, _ in
//            self.networkStatus = .reconnecting
        }
    }

    func disconnectCompoundSocket() {
        compoundSocket.disconnect()
        compoundSocket.removeAllHandlers()
    }

    func stopCompoundTimer() {
        guard let timer = compoundSocketTimer else { return }
        timer.invalidate()
    }

    func startCompoundTimer() {
        self.compoundSocketTimer = Timer.scheduledTimer(withTimeInterval: portfolioRefreshInterval, repeats: true) { _ in
            self.emitCompoundRequest()
        }
    }

    func emitCompoundRequest() {
        self.compoundSocket.emit("get", ["scope": ["info", "deposits", "assets", "actions", "loans"],
                                        "payload": ["address": self.currentUser.address, "currency": self.currentUser.currency]])
    }

    func setCompoundSockets() {
        self.compoundSocket.on("received compound info") { data, _ in
            DispatchQueue.main.async {
                print("the compound info value is: \(data)")
            }
        }

        self.compoundSocket.on("received compound deposits") { data, _ in
            DispatchQueue.main.async {
                print("the compound deposits value is: \(data)")
            }
        }

        self.compoundSocket.on("received compound assets") { data, _ in
            DispatchQueue.main.async {
                print("the compound assets value is: \(data)")

            }
        }

        self.compoundSocket.on("received compound actions") { data, _ in
            DispatchQueue.main.async {
                print("the compound actions value is: \(data)")

            }
        }

        self.compoundSocket.on("received compound loans") { data, _ in
            DispatchQueue.main.async {
                print("the compound loans value is: \(data)")

            }
        }
    }
}
