//
//  DiscoverCoordinator.swift
//  DefiWallet (iOS)
//
//  Created by Brandon Shaw on 2/14/22.
//

import SwiftUI
import Stinsen

final class DiscoverCoordinator: NavigationCoordinatable {

    let stack = NavigationStack(initial: \DiscoverCoordinator.start)

    @Root var start = makeStart

    let currentUser: CurrentUser
    let services: AuthenticatedServices

    init(currentUser: CurrentUser, services: AuthenticatedServices) {
        self.currentUser = currentUser
        self.services = services
    }

    deinit {
        print("de-init ProfleCoordinator")
    }

}
