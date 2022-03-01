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
        WelcomeView(services: unauthenticatedServices)
    }

    @ViewBuilder func makeImportWallet() -> some View {
        ImportWalletView(services: unauthenticatedServices)
    }

    @ViewBuilder func makeGenerateWallet() -> some View {
        GenerateWalletView(services: unauthenticatedServices)
    }

    @ViewBuilder func makeEnsUsername() -> some View {
        EnsUsernameView(services: unauthenticatedServices)
    }

    @ViewBuilder func makePassword() -> some View {
       SetPasswordView(services: unauthenticatedServices)
    }

    @ViewBuilder func makeTerms() -> some View {
        TermsView(navTitle: termsHeader)
    }

}
