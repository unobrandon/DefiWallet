//
//  AuthenticatedServices.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/15/22.
//

import Foundation
import RealmSwift

class AuthenticatedServices: ObservableObject {

    enum MacTabStatus: String, Equatable {
        case wallet
        case markets
        case discover
        case invest
        case profile
        case settings
    }

    var wallet: WalletService = WalletService()
    var invest: InvestService = InvestService()

    @Published var currentUser: CurrentUser
    @Published var macTabStatus: MacTabStatus

    init(currentUser: CurrentUser) {
        self.currentUser = currentUser
        self.macTabStatus = .wallet
    }

}
