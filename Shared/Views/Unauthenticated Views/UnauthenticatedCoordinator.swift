//
//  UnauthenticatedCoordinator.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/13/22.
//

import SwiftUI
import Stinsen

final class UnauthenticatedCoordinator: NavigationCoordinatable {

    let stack = NavigationStack(initial: \UnauthenticatedCoordinator.start)
    let unauthenticatedServices = UnauthenticatedServices()
    let termsHeader = "Terms of Service"

    @Root var start = makeStart
    @Route(.push) var importWallet = makeImportWallet
    @Route(.push) var generateWallet = makeGenerateWallet
    @Route(.push) var privateKeys = makePrivateKeys
    @Route(.push) var setPassword = makePassword
    @Route(.push) var biometry = makeBiometry
    @Route(.push) var ensUsername = makeEnsUsername
    @Route(.push) var notifications = makeNotifications
    @Route(.push) var completed = makeCompleted
    @Route(.push) var terms = makeTerms

    deinit {
        print("De-init UnauthenticatedCoordinator")
    }

}
