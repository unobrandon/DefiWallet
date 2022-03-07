//
//  SetPasswordView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/28/22.
//

import SwiftUI
import LocalAuthentication

struct PasswordView: View {

    @EnvironmentObject private var unauthenticatedRouter: UnauthenticatedCoordinator.Router

    @ObservedObject private var store: UnauthenticatedServices

    @State var disablePrimaryAction: Bool = true
    @State var passwordText: String = ""

    init(services: UnauthenticatedServices) {
        self.store = services
    }

    var body: some View {
        ZStack(alignment: .center) {
            Color("baseBackground").ignoresSafeArea()

            VStack(alignment: .center, spacing: 10) {
                Spacer()

                HeaderIcon(size: 48, imageName: "lock.shield")
                    .padding(.bottom, 10)

                Text("Protect your wallet")
                    .fontTemplate(DefaultTemplate.headingSemiBold)
                    .multilineTextAlignment(.center)

                Text("Used to sign contracts & transactions.")
                    .fontTemplate(DefaultTemplate.bodyMono_secondary)
                    .multilineTextAlignment(.center)

                Spacer()
                TextFieldSingleBordered(text: passwordText, placeholder: "password", textLimit: 20, isSecure: true, initFocus: true, onEditingChanged: { text in
                    passwordText = text
                    enablePrimaryButton()
                }, onCommit: {  })
                .frame(maxWidth: Constants.iPadMaxWidth)

                HStack {
                    Text("minimum of 6 characters")
                        .fontTemplate(DefaultTemplate.caption)
                        .multilineTextAlignment(.leading)
                        .padding(.leading)
                    Spacer()
                }

                Spacer()
                RoundedInteractiveButton("Set Password", isDisabled: $disablePrimaryAction, style: .primary, systemImage: nil, action: {
                    self.disablePrimaryAction = true
                    store.registerUser(username: store.unauthenticatedWallet.address, password: passwordText, address: store.unauthenticatedWallet.address, completion: { hasENS in
                        self.store.hasEnsName = hasENS
                        self.disablePrimaryAction = false
                        let context = LAContext()
                        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil),                     !UserDefaults.standard.bool(forKey: "biometryEnabled") {
                            unauthenticatedRouter.route(to: \.biometry)
                        } else {
                            if hasENS {
                                store.checkNotificationPermission(completion: { isEnabled in
                                    if isEnabled {
                                        unauthenticatedRouter.route(to: \.completed)
                                    } else {
                                        unauthenticatedRouter.route(to: \.notifications)
                                    }
                                })
                            } else {
                                unauthenticatedRouter.route(to: \.ensUsername)
                            }
                        }
                    })
                })
                .padding(.bottom, 30)
            }.padding(.horizontal)
        }.navigationBarTitle("Create Password", displayMode: .inline)
    }

    private func enablePrimaryButton() {
        guard passwordText.count >= 6 else {
            disablePrimaryAction = true

            return
        }

        disablePrimaryAction = false
    }

}
