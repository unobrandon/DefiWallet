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

    let currentUser: CurrentUser

    init(currentUser: CurrentUser) {
        self.currentUser = currentUser
    }

    deinit {
        print("de-init ProfleCoordinator")
    }

}
