//
//  CreateWalletCoordinator+Factory.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/26/22.
//

import SwiftUI
import Stinsen

extension CreateWalletCoordinator {

    @ViewBuilder func makeStart() -> some View {
        CreateWalletView(services: services)
    }

}
