//
//  CreateWalletView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/26/22.
//

import SwiftUI

struct CreateWalletView: View {

    private let services: UnauthenticatedServices

    @ObservedObject private var store: UserOnboardingServices

    @State var doneGenerating: Bool = false

    init(services: UnauthenticatedServices) {
        self.services = services
        self.store = services.userOnboarding
    }

    var body: some View {
        NavigationView {
            // Play generating animation & show the 'username' +
            // explanation behind subdomain
            VStack(alignment: .center, spacing: 20) {
                Text("Create wallet")

                RoundedButton("Generate Wallet", style: .primary, systemImage: nil, action: {
                    #if os(iOS)
                        HapticFeedback.rigidHapticFeedback()
                    #endif
                })
            }
        }
        .navigationTitle("Create Wallet")
        #if os(iOS)
        .navigationBarBackButtonHidden(!doneGenerating)
        #endif
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + services.userOnboarding.generateWalletDelay) {
                doneGenerating = true
            }
        }
    }
}
