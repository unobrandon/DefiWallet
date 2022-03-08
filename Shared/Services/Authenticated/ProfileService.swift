//
//  ProfileService.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 3/7/22.
//

import Foundation

class ProfileService: ObservableObject {

    func logout() {
        AuthenticationService.shared.authStatus = .unauthenticated

        #if os(iOS)
            HapticFeedback.rigidHapticFeedback()
        #endif
    }

}
