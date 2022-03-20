//
//  WalletConnectDelegate.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 3/20/22.
//

import SwiftUI
import WalletConnect

extension WalletService: WalletConnectClientDelegate {

    func didUpdate(sessionTopic: String, accounts: Set<Account>) {
        print("did update session topic: \(sessionTopic) \n and the accounts: \(accounts)")
    }

    func didReceive(sessionProposal: Session.Proposal) {
        print("received session proposal: \(sessionProposal)")
        DispatchQueue.main.async {
            self.walletConnectProposal = sessionProposal
        }
    }

    func didSettle(session: Session) {
        print("did settle: \(session)")
    }

    func didDelete(sessionTopic: String, reason: Reason) {
        print("did delete session topic: \(sessionTopic) \nfor reason: \(reason)")
    }

    func didUpgrade(sessionTopic: String, permissions: Session.Permissions) {
        print("did upgrade session topic: \(sessionTopic) \nand the permissions are: \(permissions)")
    }

}
