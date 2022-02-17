//
//  AuthenticatedServices.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/15/22.
//

import Foundation
import RealmSwift

class AuthenticatedServices: ObservableObject {

    var wallet: WalletService = WalletService()
    var invest: InvestService = InvestService()

    @Published var currentUser: CurrentUser

    init(currentUser: CurrentUser) {
        self.currentUser = currentUser
    }

}
