//
//  WalletCoordinator.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/13/22.
//

import SwiftUI
import Stinsen

final class WalletCoordinator: NavigationCoordinatable {

    let stack = NavigationStack(initial: \WalletCoordinator.start)

    @Root var start = makeStart

    let services: AuthenticatedServices

    init(services: AuthenticatedServices) {
        self.services = services
    }

    deinit {
        print("de-init WomeCoordinator")
    }

}
