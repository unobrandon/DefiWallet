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
    let services: AuthenticatedServices

    init(currentUser: CurrentUser, services: AuthenticatedServices) {
        self.currentUser = currentUser
        self.services = services
    }

    deinit {
        print("de-init ProfleCoordinator")
    }

}
