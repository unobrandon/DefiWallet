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

    @Root var start = makeStart
//    @Route(.push) var forgotPassword = makeForgotPassword
//    @Route(.push) var registration = makeRegistration

    deinit {
        print("Deinit UnauthenticatedCoordinator")
    }
}
