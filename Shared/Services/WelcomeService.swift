//
//  WelcomeService.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/13/22.
//

import Foundation

class WelcomeServices: ObservableObject {

    func newWallet(completion: (() -> Void)?) {
        DispatchQueue.main.async {
            AuthenticationService.shared.authStatus = .authenticated(
                CurrentUser(accessToken: UUID().uuidString,
                            username: "testUsernamelol",
                            ethAddress: "",
                            accountValue: "0.00",
                            secretPhrase: "")
            )

            completion?()
        }
    }

    func importWallet(completion: (() -> Void)?) {
        DispatchQueue.main.async {
            print("import wallet")
            completion?()
        }
    }

}
