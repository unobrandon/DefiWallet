//
//  MarketsCoordinator.swift
//  DefiWallet (iOS)
//
//  Created by Brandon Shaw on 2/14/22.
//

import SwiftUI
import Stinsen

final class MarketsCoordinator: NavigationCoordinatable {

    let stack = NavigationStack(initial: \MarketsCoordinator.start)

    @Root var start = makeStart
    @Route(.push) var trendingDetail = makeTrendingDetail
    @Route(.push) var marketCapRank = makeMarketCapRank

    let currentUser: CurrentUser
    let services: AuthenticatedServices

    init(currentUser: CurrentUser, services: AuthenticatedServices) {
        self.currentUser = currentUser
        self.services = services
    }

    deinit {
        print("de-init Markets Coordinator")
    }

}
