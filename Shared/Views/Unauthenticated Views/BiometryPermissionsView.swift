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

                HeaderIcon(size: 48, imageName: "lock.fill")
                    .padding(.bottom)

                Text("Protect your wallet")
                    .fontTemplate(DefaultTemplate.headingSemiBold)
                    .multilineTextAlignment(.center)

                Text("Enable biometric security to help protect your wallet when signing smart contracts and transactions.")
                    .fontTemplate(DefaultTemplate.bodyMono_secondary)
                    .multilineTextAlignment(.center)

                Spacer()
                BiometryBanner(style: .border, onSuccess: {
                    UserDefaults.standard.setValue(true, forKey: "biometryEnabled")

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
                })
                .frame(maxWidth: Constants.iPadMaxWidth)

                Spacer()
                RoundedButton("Next", style: .primary, systemImage: nil, action: {
                    unauthenticatedRouter.route(to: \.ensUsername)
                })
                .padding(.bottom)
            }.padding(.horizontal)
        }.navigationBarTitle("Enable Permission", displayMode: .inline)
        #if os(iOS)
        .navigationBarBackButtonHidden(true)
        #endif
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    unauthenticatedRouter.route(to: \.ensUsername)
                    #if os(iOS)
                        HapticFeedback.lightHapticFeedback()
                    #endif
                }, label: Text("skip").foregroundColor(.secondary))
            }
        }
    }

}
