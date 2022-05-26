//
//  DefiWalletApp.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/9/22.
//

import SwiftUI
import Stinsen

@main
struct DefiWalletApp: App {

    var body: some Scene {
        WindowGroup {
            MainCoordinator().view()
        }
    }

}
