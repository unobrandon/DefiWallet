//
//  ProfileCoordinator+Factory.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/13/22.
//

import SwiftUI
import Stinsen

extension ProfileCoordinator {

    @ViewBuilder func makeStart() -> some View {
        ProfileView(service: services)
    }

}
