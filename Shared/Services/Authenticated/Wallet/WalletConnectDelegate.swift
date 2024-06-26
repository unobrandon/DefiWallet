//
//  WalletConnectDelegate.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 3/20/22.
//

import SwiftUI
import web3swift

/*
extension WalletService: WalletConnectClientDelegate {

    func connectDapp(uri: String, completion: @escaping (Bool) -> Void) {
//        do {
//            try self.walletConnectClient.pair(uri: uri)
//
//            DispatchQueue.main.async { completion(true) }
//        } catch {
//            DispatchQueue.main.async { completion(false) }
//        }
    }

    func disconnectDapp(sessionTopic: String) {
//        DispatchQueue.global(qos: .userInteractive).async {
//            self.walletConnectClient.disconnect(topic: sessionTopic, reason: Reason(code: 0, message: "User disconnected from \(Constants.projectName)"))
//
//            self.reloadWcSessions()
//            HapticFeedback.successHapticFeedback()
//        }
    }

    func reloadWcSessions() {
//        let settledSessions = walletConnectClient.getSettledSessions()
//        let activeSessions = getActiveSessionItem(for: settledSessions)
//
//        DispatchQueue.main.async {
//            self.wcActiveSessions = activeSessions
//        }
    }

    func didUpdate(sessionTopic: String, accounts: Set<Account>) {
        print("did update session topic: \(sessionTopic) \n and the accounts: \(accounts)")
    }

    func didReceive(sessionProposal: Session.Proposal) {
        print("received session proposal: \(sessionProposal)")
//        self.wcProposal = sessionProposal
    }

    func didReceive(sessionRequest: Request) {
        print("received session request: \(sessionRequest)")

        if sessionRequest.method == "personal_sign" {
            do {
                let params = try sessionRequest.params.get([String].self)
                print("personal_sign data is: \(params.debugDescription)")
            } catch {

            }
        } else if sessionRequest.method == "eth_signTypedData" {
            do {
                let params = try sessionRequest.params.get([String].self)
                print("eth sign type data is: \(params.debugDescription)")
            } catch {

            }
        } else if sessionRequest.method == "eth_sendTransaction" {
            do {
//                let params = try sessionRequest.params.get([EthereumTransaction].self)
            }
        }
    }

    func didSettle(session: Session) {
        print("did settle: \(session)")
        reloadWcSessions()
    }

    func didDelete(sessionTopic: String, reason: Reason) {
        print("did delete session topic: \(sessionTopic) \nfor reason: \(reason)")
        reloadWcSessions()

        #if(ios)
        showNotiHUD(image: "wifi.slash", color: Color("AccentColor"), title: "Dapp disconnected", subtitle: reason.message)
        #endif
    }

    func didUpgrade(sessionTopic: String, permissions: Session.Permissions) {
        DispatchQueue.main.async {
            print("did upgrade session topic: \(sessionTopic) \nand the permissions are: \(permissions)")
        }
    }

    private func getActiveSessionItem(for settledSessions: [Session]) -> [WCSessionInfo] {
        return settledSessions.map { session -> WCSessionInfo in
            let app = session.peer
            return WCSessionInfo(
                name: app.name ?? "",
                descriptionText: app.description ?? "",
                dappURL: app.url ?? "",
                iconURL: app.icons?.first ?? "",
                topic: session.topic,
                chains: Array(session.permissions.blockchains),
                methods: Array(session.permissions.methods), pendingRequests: [])
        }
    }

    func viewDappWebsite(link: String) {
        print("visit dapp's website: \(link)")
    }

}
*/
