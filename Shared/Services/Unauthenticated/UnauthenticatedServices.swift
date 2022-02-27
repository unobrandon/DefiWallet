//
//  UnauthenticatedServices.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/13/22.
//

import SwiftUI

class UnauthenticatedServices: ObservableObject {

    var userOnboarding: UserOnboardingServices = UserOnboardingServices()

    init() {

    }

    func pasteText() -> String {
        guard let clipboard = UIPasteboard.general.string else {
            return ""
        }

        return clipboard.cleanUpPastedText()
    }

}
