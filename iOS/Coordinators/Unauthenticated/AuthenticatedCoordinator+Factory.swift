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
        return NavigationViewCoordinator(WalletCoordinator(services: authenticatedServices))
    }

    @ViewBuilder func makeWalletTab(isActive: Bool) -> some View {
        Image(systemName: "house" + (isActive ? ".fill" : ""))
        Text("Wallet")
    }

    func makeMarkets() -> NavigationViewCoordinator<MarketsCoordinator> {
        return NavigationViewCoordinator(MarketsCoordinator(currentUser: currentUser))
    }

    @ViewBuilder func makeMarketsTab(isActive: Bool) -> some View {
        Image(systemName: "chart.bar" + (isActive ? ".fill" : ""))
        Text("Markets")
    }

    func makeDiscover() -> NavigationViewCoordinator<DiscoverCoordinator> {
        return NavigationViewCoordinator(DiscoverCoordinator(currentUser: currentUser))
    }

    @ViewBuilder func makeDiscoverTab(isActive: Bool) -> some View {
        Image(systemName: "safari" + (isActive ? ".fill" : ""))
        Text("Discover")
    }

    func makeInvest() -> NavigationViewCoordinator<InvestCoordinator> {
        return NavigationViewCoordinator(InvestCoordinator(services: authenticatedServices))
    }

    @ViewBuilder func makeInvestTab(isActive: Bool) -> some View {
        Image(systemName: "leaf" + (isActive ? ".fill" : ""))
        Text("Invest")
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
