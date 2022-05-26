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

    #if targetEnvironment(macCatalyst)
        @Root var macauthenticated = makeMacAuthenticated
    #elseif os(macOS)
        @Root var macauthenticated = makeMacAuthenticated
    #elseif os(iOS)
        @Root var authenticated = makeAuthenticated
    #endif

    init() {
        switch AuthenticationService.shared.authStatus {
        case .authenticated(let user):
            #if targetEnvironment(macCatalyst)
                stack = NavigationStack(initial: \MainCoordinator.macauthenticated, user)
            #elseif os(macOS)
                stack = NavigationStack(initial: \MainCoordinator.macauthenticated, user)
            #elseif os(iOS)
                stack = NavigationStack(initial: \MainCoordinator.authenticated, user)
            #endif
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
                    #if targetEnvironment(macCatalyst)
                        self.root(\.macauthenticated, user)
                    #elseif os(macOS)
                        self.root(\.macauthenticated, user)
                    #elseif os(iOS)
                        self.root(\.authenticated, user)
                    #else
                        self.root(\.authenticated, user)
                    #endif
                }
            })
    }

}
