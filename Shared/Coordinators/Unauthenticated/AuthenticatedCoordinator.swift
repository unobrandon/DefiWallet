//
//  Authenticated.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/13/22.
//

import SwiftUI
import Stinsen

final class AuthenticatedCoordinator: TabCoordinatable {

    var child = TabChild(
        startingItems: [
            \AuthenticatedCoordinator.wallet,
            \AuthenticatedCoordinator.profile
        ])

    let currentUser: CurrentUser

    @Route(tabItem: makeWalletTab) var wallet = makeWallet
    @Route(tabItem: makeProfileTab) var profile = makeProfile

    init(user: CurrentUser) {
        self.currentUser = user
    }

    deinit {
        print("de-init authenticatedCoordinator")
    }
}
