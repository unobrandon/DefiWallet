//
//  SetPasswordView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/28/22.
//

import SwiftUI

struct PasswordView: View {

    @EnvironmentObject private var unauthenticatedRouter: UnauthenticatedCoordinator.Router

    @ObservedObject private var store: UserOnboardingServices

    @State var disablePrimaryAction: Bool = true
    @State var passwordText: String = ""
    @State var confirmPasswordText: String = ""

    init(services: UnauthenticatedServices) {
        self.store = services.userOnboarding
    }

    var body: some View {
        ZStack(alignment: .center) {
            Color("baseBackground").ignoresSafeArea()

            VStack(alignment: .center, spacing: 0) {
                Spacer()

                HeaderIcon(size: 48, imageName: "lock.shield")
                    .padding(.bottom)

                Text("Set a password and protects your keys.\nUsed to sign contracts & transactions.")
                    .fontTemplate(DefaultTemplate.subheadingSemiBold)
                    .padding(.horizontal)
                    .multilineTextAlignment(.center)

                Spacer()
                TextFieldSingleBordered(text: passwordText, placeholder: "password", textLimit: 20, isSecure: true, onEditingChanged: { text in
                    print("password changed: \(text)")
                }, onCommit: {
                    print("returned username ehh")
                })
                .frame(maxWidth: Constants.iPadMaxWidth)
                .padding(.bottom)

                TextFieldSingleBordered(text: confirmPasswordText, placeholder: "confirm password", textLimit: 20, isSecure: true, onEditingChanged: { text in
                    print("confirm password changed: \(text)")
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
                TermsOfServiceButton(action: {
                    unauthenticatedRouter.route(to: \.terms)
                })
                .padding(.bottom)

                RoundedInteractiveButton("Set Password", isDisabled: $disablePrimaryAction, style: .primary, systemImage: nil, action: {
                    print("set password")
                })
                .padding(.bottom, 10)
            }
        }.navigationBarTitle("Create Password", displayMode: .inline)
    }

}
