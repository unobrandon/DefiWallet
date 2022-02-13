//
//  ProfileCoordinator.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/13/22.
//

import SwiftUI
import Stinsen

final class ProfileCoordinator: NavigationCoordinatable {

    let stack = NavigationStack(initial: \ProfileCoordinator.start)

    @Root var start = makeStart

    let currentUser: CurrentUser

    init(currentUser: CurrentUser) {
        self.currentUser = currentUser
    }

    deinit {
        print("de-init ProfleCoordinator")
    }

}
