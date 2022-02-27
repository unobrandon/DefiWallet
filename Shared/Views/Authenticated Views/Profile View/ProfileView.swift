//
//  ProfileView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/13/22.
//

import SwiftUI
import Stinsen

struct ProfileView: View {

    var body: some View {        
        ZStack {
            Color("baseBackground").ignoresSafeArea()

            ScrollView {
                Text("It's the Profile view!!")

                RoundedButton("Log Out", style: .bordered, systemImage: "", action: {
                    AuthenticationService.shared.authStatus = .unauthenticated
                })
            }
        }
        .navigationTitle("Profile")
    }

}
