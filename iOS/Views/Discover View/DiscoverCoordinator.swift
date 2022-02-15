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

    init(currentUser: CurrentUser) {
        self.currentUser = currentUser
    }

    deinit {
        print("de-init ProfleCoordinator")
    }

}
