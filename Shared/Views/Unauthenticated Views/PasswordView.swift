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
    @State var confirmPasswordText: String = ""

    init(services: UnauthenticatedServices) {
        self.store = services
    }

    var body: some View {
        ZStack(alignment: .center) {
            Color("baseBackground").ignoresSafeArea()

            VStack(alignment: .center, spacing: 0) {
                Spacer()

                HeaderIcon(size: 48, imageName: "lock.shield")
                    .padding(.bottom)

                Text("Set a password to protects your wallet.\nUsed to sign contracts & transactions.")
                    .fontTemplate(DefaultTemplate.subheadingSemiBold)
                    .padding(.horizontal)
                    .multilineTextAlignment(.center)

                Spacer()
                TextFieldSingleBordered(text: passwordText, placeholder: "password", textLimit: 20, isSecure: true, onEditingChanged: { text in
                    print("password changed: \(text)")
                    passwordText = text
                    enablePrimaryButton()
                }, onCommit: {
                    print("returned username ehh")
                })
                .frame(maxWidth: Constants.iPadMaxWidth)
                .padding(.bottom)

                TextFieldSingleBordered(text: confirmPasswordText, placeholder: "confirm password", textLimit: 20, isSecure: true, onEditingChanged: { text in
                    print("confirm password changed: \(text)")
                    confirmPasswordText = text
                    enablePrimaryButton()
                }, onCommit: {
                    print("returned username ehh")
                })
                .frame(maxWidth: Constants.iPadMaxWidth)
                .padding(.bottom, 10)

                HStack {
                    Text("minimum of 6 characters")
                        .fontTemplate(DefaultTemplate.caption)
                        .padding(.horizontal)
                        .multilineTextAlignment(.leading)
                    Spacer()
                }

                Spacer()
                RoundedInteractiveButton("Set Password", isDisabled: $disablePrimaryAction, style: .primary, systemImage: nil, action: {
                    let context = LAContext()
                    if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
                        unauthenticatedRouter.route(to: \.permissions)
                    } else {
                        unauthenticatedRouter.route(to: \.ensUsername)
                    }
                })
                .padding(.bottom, 10)
            }
        }.navigationBarTitle("Create Password", displayMode: .inline)
    }

    private func enablePrimaryButton() {
        guard passwordText.count >= 6, confirmPasswordText.count >= 6, passwordText == confirmPasswordText else {
            disablePrimaryAction = true

            return
        }

        withAnimation {
            disablePrimaryAction = false
        }
    }

}
