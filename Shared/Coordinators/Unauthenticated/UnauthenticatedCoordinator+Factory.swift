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

}
