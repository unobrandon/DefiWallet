//
//  AuthenticatedCoordinator+Factory.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/13/22.
//

import SwiftUI
import Stinsen

extension AuthenticatedCoordinator {

    func makeWallet() -> NavigationViewCoordinator<WalletCoordinator> {
        return NavigationViewCoordinator(WalletCoordinator(currentUser: currentUser))
    }

    @ViewBuilder func makeWalletTab(isActive: Bool) -> some View {
        Image(systemName: "house" + (isActive ? ".fill" : ""))
        Text("Wallet")
    }

    func makeProfile() -> NavigationViewCoordinator<ProfileCoordinator> {
        return NavigationViewCoordinator(ProfileCoordinator(currentUser: currentUser))
    }

    @ViewBuilder func makeProfileTab(isActive: Bool) -> some View {
        Image(systemName: "person.crop.circle" + (isActive ? ".fill" : ""))
            .offset(y: 30)
        Text("Profile")
    }

}
