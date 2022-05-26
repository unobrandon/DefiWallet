//
//  MacAuthenticationCoordinator.swift
//  DefiWallet (macOS)
//
//  Created by Brandon Shaw on 2/18/22.
//

import SwiftUI
import Stinsen

final class MacAuthenticatedCoordinator: NavigationCoordinatable {

    var stack = NavigationStack(initial: \MacAuthenticatedCoordinator.wallet)

    var authenticatedServices: AuthenticatedServices
    let currentUser: CurrentUser

    @Root var wallet = makeWallet
    @Root var markets = makeMarkets
    @Root var discover = makeDiscover
    @Root var invest = makeInvest
    @Root var profile = makeProfile

    init(user: CurrentUser) {
        self.authenticatedServices = AuthenticatedServices(currentUser: user)
        self.currentUser = user

        // Load init network requests and
        // other configuration here for ALL tabs
    }

    deinit {
        print("de-init authenticatedCoordinator")
    }

    @ViewBuilder func customize(_ view: AnyView) -> some View {
        NavigationView {
            // Note: Can not set 'min/maxWidth'. Set it in the content view.
            SideNavigationBar(services: authenticatedServices)

            view
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("baseBackground"))
                .animation(.none)
                .onReceive(self.authenticatedServices.$macTabStatus, perform: { status in
                    switch status {
                    case .wallet:
                        self.root(\.wallet)
                    case .markets:
                        self.root(\.markets)
                    case .discover:
                        self.root(\.discover)
                    case .invest:
                        self.root(\.invest)
                    case .profile:
                        self.root(\.profile)
                    case .settings:
                        self.root(\.profile)
                    }
                })
        }
        .ignoresSafeArea(.all, edges: .all)
        .frame(maxWidth: MacConstants.screenWidth / 1.5, maxHeight: MacConstants.screenHeight / 1.5)
        .frame(minWidth: 650, minHeight: 200)
        .frame(idealWidth: 1050, idealHeight: 950)
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button(action: toggleSidebar, label: {
                    Image(systemName: "sidebar.leading")
                })
            }
        }
    }

    private func toggleSidebar() {
        NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
    }

}
