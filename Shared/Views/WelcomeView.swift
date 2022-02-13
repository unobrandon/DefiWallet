//
//  WelcomeView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/13/22.
//

import SwiftUI
import Stinsen

struct WelcomeView: View {

    @EnvironmentObject private var unauthenticatedRouter: UnauthenticatedCoordinator.Router

    private let services: UnauthenticatedServices

    init(services: UnauthenticatedServices) {
        self.services = services
    }

    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Text("Welcome! So Excited!")
                .font(.headline)
                .foregroundColor(.primary)
                .padding()

            RoundedButton("Create New Wallet", style: .primary, systemImage: "paperplane.fill", action: {
                services.welcome.newWallet(completion: nil)
            })

            RoundedButton("Import Wallet", style: .secondary, systemImage: nil, action: {
                services.welcome.importWallet(completion: nil)
            })
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView(services: UnauthenticatedServices())
    }
}
