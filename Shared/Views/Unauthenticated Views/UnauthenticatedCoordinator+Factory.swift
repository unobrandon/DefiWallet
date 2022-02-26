//
//  UnauthenticatedCoordinator+Factory.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/13/22.
//

import SwiftUI
import Stinsen

extension UnauthenticatedCoordinator {

    @ViewBuilder func makeStart() -> some View {
        WelcomeView()
    }

    @ViewBuilder func makeImportWallet() -> some View {
        ImportWalletView(services: unauthenticatedServices)
    }

    @ViewBuilder func makeCreateWallet() -> some View {
        CreateWalletView(services: unauthenticatedServices)
    }

}
