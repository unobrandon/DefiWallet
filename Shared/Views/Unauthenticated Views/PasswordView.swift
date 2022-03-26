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
    @State var isLoading: Bool = false
    @State var registerError: Bool = false
    @State var passwordText: String = ""

    init(services: UnauthenticatedServices) {
        self.store = services
    }

    var body: some View {
        ZStack(alignment: .center) {
            Color("baseBackground").ignoresSafeArea()

            VStack(alignment: .center, spacing: 10) {
                Spacer()

                OnboardingHeaderView(imageName: "lock.shield",
                                     title: "Protect your wallet",
                                     subtitle: "Used to sign contracts & transactions.")

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
                .frame(maxWidth: Constants.iPadMaxWidth)

                Spacer()
                if isLoading {
                    LoadingIndicator(size: 30).padding(.bottom, 30)
                } else {
                    if registerError {
                        Text("error occurred, please try again")
                            .fontTemplate(DefaultTemplate.captionError)
                            .padding(.bottom)
                    }

                    RoundedInteractiveButton("Set Password", isDisabled: $disablePrimaryAction, style: .primary, systemImage: nil, action: {
                        setPassword()
                    })
                    .padding(.bottom, 30)
                }
            }.padding(.horizontal)
        }.navigationBarTitle("Create Password", displayMode: .inline)
    }

    private func setPassword() {
        self.disablePrimaryAction = true
        self.isLoading = true

        store.registerUser(username: store.unauthenticatedWallet.address.formatAddress(),
                           password: passwordText,
                           address: store.unauthenticatedWallet.address,
                           currency: store.prefCurrency,
                           completion: { result in
            self.registerError = !result
            self.store.password = passwordText
            self.isLoading = false
            self.disablePrimaryAction = false

            guard result else {
                HapticFeedback.errorHapticFeedback()
                return
            }

            let context = LAContext()
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil),                     !UserDefaults.standard.bool(forKey: "biometryEnabled") {
                unauthenticatedRouter.route(to: \.biometry)
            } else {
//                if hasENS {
//                    store.checkNotificationPermission(completion: { isEnabled in
//                        if isEnabled {
//                            unauthenticatedRouter.route(to: \.completed)
//                        } else {
//                            unauthenticatedRouter.route(to: \.notifications)
//                        }
//                    })
//                } else {
                    unauthenticatedRouter.route(to: \.ensUsername)
//                }
            }
        })
    }

    private func enablePrimaryButton() {
        guard passwordText.count >= 6 else {
            disablePrimaryAction = true

            return
        }

        disablePrimaryAction = false
    }

}
