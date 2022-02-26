//
//  CreateWalletCoordinator.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/26/22.
//

import SwiftUI
import Stinsen

final class CreateWalletCoordinator: NavigationCoordinatable {

    let stack = NavigationStack(initial: \CreateWalletCoordinator.start)

    @Root var start = makeStart

    let services: UnauthenticatedServices

    init(services: UnauthenticatedServices) {
        self.services = services
    }

    deinit {
        print("de-init CreateWalletCoordinator")
    }

}
