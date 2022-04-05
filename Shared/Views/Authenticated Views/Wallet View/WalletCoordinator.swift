//
//  WalletCoordinator.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/13/22.
//

import SwiftUI
import Stinsen

final class WalletCoordinator: NavigationCoordinatable {

    let stack = NavigationStack(initial: \WalletCoordinator.start)

    @Root var start = makeStart
    @Route(.push) var networkDetail = makeNetworkDetail
    @Route(.push) var history = makeHistory
    @Route(.push) var historyDetail = makeHistoryDetail
    @Route(.modal) var safari = makeSafari

    let currentUser: CurrentUser
    let services: AuthenticatedServices

    init(currentUser: CurrentUser, services: AuthenticatedServices) {
        self.currentUser = currentUser
        self.services = services
    }

    deinit {
        print("de-init WomeCoordinator")
    }

}
