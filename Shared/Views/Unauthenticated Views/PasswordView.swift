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

            VStack(alignment: .center, spacing: 0) {
                Spacer()

                HeaderIcon(size: 48, imageName: "lock.shield")
                    .padding(.bottom)

                Text("Protect your wallet")
                    .fontTemplate(DefaultTemplate.headingSemiBold)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 10)

                Text("Used to sign contracts & transactions.")
                    .fontTemplate(DefaultTemplate.bodyMono_secondary)
                    .multilineTextAlignment(.center)

                Spacer()
                TextFieldSingleBordered(text: passwordText, placeholder: "password", textLimit: 20, isSecure: true, initFocus: true, onEditingChanged: { text in
                    print("password changed: \(text)")
                    passwordText = text
                    enablePrimaryButton()
                }, onCommit: {
                    print("returned username ehh")
                })
                .frame(maxWidth: Constants.iPadMaxWidth)
                .padding(.bottom, 10)

                HStack {
                    Text("minimum of 6 characters")
                        .fontTemplate(DefaultTemplate.caption)
                        .multilineTextAlignment(.leading)
                        .padding(.leading)
                    Spacer()
                }

                Spacer()
                RoundedInteractiveButton("Set Password", isDisabled: $disablePrimaryAction, style: .primary, systemImage: nil, action: {

                    let context = LAContext()
                    if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil),                     !UserDefaults.standard.bool(forKey: "biometryEnabled") {
                        unauthenticatedRouter.route(to: \.biometry)
                    } else {
                        unauthenticatedRouter.route(to: \.ensUsername)
                    }
                })
                .padding(.bottom)
            }.padding(.horizontal)
        }.navigationBarTitle("Create Password", displayMode: .inline)
    }

    private func enablePrimaryButton() {
        guard passwordText.count >= 6 else {
            disablePrimaryAction = true

            return
        }

        withAnimation {
            disablePrimaryAction = false
        }
    }

}
