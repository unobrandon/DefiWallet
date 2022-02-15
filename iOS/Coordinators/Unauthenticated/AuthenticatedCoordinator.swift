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
             \AuthenticatedCoordinator.markets,
             \AuthenticatedCoordinator.discover,
             \AuthenticatedCoordinator.invest,
             \AuthenticatedCoordinator.profile
        ])

    let currentUser: CurrentUser

    @Route(tabItem: makeWalletTab) var wallet = makeWallet
    @Route(tabItem: makeMarketsTab) var markets = makeMarkets
    @Route(tabItem: makeDiscoverTab) var discover = makeDiscover
    @Route(tabItem: makeInvestTab) var invest = makeInvest
    @Route(tabItem: makeProfileTab) var profile = makeProfile

    init(user: CurrentUser) {
        self.currentUser = user

        // Load init network requests and
        // other configuration here for ALL tabs
    }

    deinit {
        print("de-init authenticatedCoordinator")
    }

}
