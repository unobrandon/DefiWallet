//
//  ProfileView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/13/22.
//

import SwiftUI
import Stinsen

struct ProfileView: View {

    init() {

    }

    var body: some View {
        ScrollView {
            Text("It's the profile view!!")

            RoundedButton("Log Out", style: .bordered, systemImage: "", action: {
                AuthenticationService.shared.authStatus = .unauthenticated
            })
        }
        .navigationTitle("Profile")
    }

}
