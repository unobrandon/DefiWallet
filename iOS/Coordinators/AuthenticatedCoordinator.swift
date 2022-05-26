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

    let authenticatedServices: AuthenticatedServices
    let currentUser: CurrentUser

    @Route(tabItem: makeWalletTab) var wallet = makeWallet
    @Route(tabItem: makeMarketsTab) var markets = makeMarkets
    @Route(tabItem: makeDiscoverTab) var discover = makeDiscover
    @Route(tabItem: makeInvestTab) var invest = makeInvest
    @Route(tabItem: makeProfileTab) var profile = makeProfile

    init(user: CurrentUser) {
        self.authenticatedServices = AuthenticatedServices(currentUser: user)
        self.currentUser = user
    }

    deinit {
        print("de-init authenticatedCoordinator")
    }

}
