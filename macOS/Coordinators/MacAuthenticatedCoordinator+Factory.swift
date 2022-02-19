//
//  MacAuthenticationCoordinator+Factory.swift
//  DefiWallet (macOS)
//
//  Created by Brandon Shaw on 2/18/22.
//

import SwiftUI
import Stinsen

extension MacAuthenticatedCoordinator {

    func makeWallet() -> WalletCoordinator {
        return WalletCoordinator(services: authenticatedServices)
    }

    func makeMarkets() -> MarketsCoordinator {
        return MarketsCoordinator(currentUser: currentUser)
    }

    func makeDiscover() -> DiscoverCoordinator {
        return DiscoverCoordinator(currentUser: currentUser)
    }

    func makeInvest() -> InvestCoordinator {
        return InvestCoordinator(services: authenticatedServices)
    }

    func makeProfile() -> ProfileCoordinator {
        return ProfileCoordinator(currentUser: currentUser)
    }

}
