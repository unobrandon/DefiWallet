//
//  AuthenticatedServices.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/15/22.
//

import Foundation

class AuthenticatedServices: ObservableObject {

    var wallet: WalletService = WalletService()

    @Published var currentUser: CurrentUser

    init(currentUser: CurrentUser) {
        self.currentUser = currentUser
    }

}
