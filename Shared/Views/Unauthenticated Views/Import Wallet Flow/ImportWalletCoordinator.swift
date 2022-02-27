//
//  ImportWalletCoordinator.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/26/22.
//

import SwiftUI
import Stinsen

final class ImportWalletCoordinator: NavigationCoordinatable {

    let stack = NavigationStack(initial: \ImportWalletCoordinator.start)

    @Root var start = makeStart

    let services: UnauthenticatedServices

    init(services: UnauthenticatedServices) {
        self.services = services
    }

    deinit {
        print("de-init WomeCoordinator")
    }

}
