//
//  ImportWalletCoordinator+Factory.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/26/22.
//

import SwiftUI
import Stinsen

extension ImportWalletCoordinator {

    @ViewBuilder func makeStart() -> some View {
        ImportWalletView(services: services)
    }

}
