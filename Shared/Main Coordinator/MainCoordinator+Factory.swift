//
//  MainCoordinator+Factory.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/13/22.
//

import SwiftUI
import Stinsen

extension MainCoordinator {

    func makeUnauthenticated() -> NavigationViewCoordinator<UnauthenticatedCoordinator> {
        return NavigationViewCoordinator(UnauthenticatedCoordinator())
    }

    #if targetEnvironment(macCatalyst)
        func makeMacAuthenticated(currentUser: CurrentUser) -> MacAuthenticatedCoordinator {
            return MacAuthenticatedCoordinator(user: currentUser)
        }
    #elseif os(macOS)
        func makeMacAuthenticated(currentUser: CurrentUser) -> MacAuthenticatedCoordinator {
            return MacAuthenticatedCoordinator(user: currentUser)
        }
    #elseif os(iOS)
        func makeAuthenticated(currentUser: CurrentUser) -> AuthenticatedCoordinator {
            return AuthenticatedCoordinator(user: currentUser)
        }
    #endif

}
