//
//  EnablePermissionsView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 3/5/22.
//

import SwiftUI

struct BiometryPermissionsView: View {

    @EnvironmentObject private var unauthenticatedRouter: UnauthenticatedCoordinator.Router

    @ObservedObject private var store: UnauthenticatedServices

    init(services: UnauthenticatedServices) {
        self.store = services
    }

    var body: some View {
        ZStack(alignment: .center) {
            Color("baseBackground").ignoresSafeArea()

            VStack(alignment: .center, spacing: 20) {
                Spacer()

                OnboardingHeaderView(imageName: "lock.fill",
                                     title: "Protect your wallet",
                                     subtitle: "Enable biometric security to help protect your wallet when signing smart contracts and transactions.")

                Spacer()
                BiometryBanner(style: .border, onSuccess: {
                    next()
                })
                .frame(maxWidth: Constants.iPadMaxWidth)

                Spacer()
                RoundedButton("Next", style: .primary, systemImage: nil, action: {
                    next()
                })
                .padding(.bottom)
            }
        }.navigationBarTitle("Enable Permission", displayMode: .inline)
        #if os(iOS)
        .navigationBarBackButtonHidden(true)
        #endif
    }

    private func next() {
        if !self.store.hasEnsName {
            unauthenticatedRouter.route(to: \.ensUsername)
        } else {
            store.checkNotificationPermission(completion: { isEnabled in
                if isEnabled {
                    unauthenticatedRouter.route(to: \.completed)
                } else {
                    unauthenticatedRouter.route(to: \.notifications)
                }
            })
        }

        #if os(iOS)
            HapticFeedback.lightHapticFeedback()
        #endif
    }

}
