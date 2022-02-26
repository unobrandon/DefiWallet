//
//  ImportWalletView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/26/22.
//

import SwiftUI

struct ImportWalletView: View {

    private let services: UnauthenticatedServices

    @ObservedObject private var store: UserOnboardingServices

    init(services: UnauthenticatedServices) {
        self.services = services
        self.store = services.userOnboarding
    }

    var body: some View {
        NavigationView {
            Text("import wallet view")
        }
        .navigationTitle("Import Wallet")
    }
}
