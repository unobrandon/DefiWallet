//
//  MainCoordinator.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/13/22.
//

import SwiftUI
import Stinsen

final class MainCoordinator: NavigationCoordinatable {
    var stack: NavigationStack<MainCoordinator>

    @Root var unauthenticated = makeUnauthenticated
    @Root var authenticated = makeAuthenticated

    init() {
        switch AuthenticationService.shared.authStatus {
        case .authenticated(let user):
            stack = NavigationStack(initial: \MainCoordinator.authenticated, user)
        case .unauthenticated:
            stack = NavigationStack(initial: \MainCoordinator.unauthenticated)
        }
    }

    deinit {
        print("de-init main coordinator")
    }

    @ViewBuilder func customize(_ view: AnyView) -> some View {
        view
            .onReceive(AuthenticationService.shared.$authStatus, perform: { status in
                switch status {
                case .unauthenticated:
                    self.root(\.unauthenticated)
                case .authenticated(let user):
                    self.root(\.authenticated, user)
                }
            })

    }
}
