//
//  SetPasswordView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/28/22.
//

import SwiftUI

struct SetPasswordView: View {

    @EnvironmentObject private var unauthenticatedRouter: UnauthenticatedCoordinator.Router

    @ObservedObject private var store: UserOnboardingServices

    @State var disableSetPassword: Bool = true
    @State var passwordText: String = ""
    @State var confirmPasswordText: String = ""

    init(services: UnauthenticatedServices) {
        self.store = services.userOnboarding
    }

    var body: some View {
        ZStack(alignment: .center) {
            Color("baseBackground").ignoresSafeArea()

            VStack(alignment: .center, spacing: 20) {
                Spacer()

                TextFieldSingleBordered(text: passwordText, placeholder: "password", textLimit: 20, isSecure: true, onEditingChanged: { text in
                    print("password changed: \(text)")
                }, onCommit: {
                    print("returned username ehh")
                })
                .frame(maxWidth: Constants.iPadMaxWidth)

                TextFieldSingleBordered(text: confirmPasswordText, placeholder: "confirm password", textLimit: 20, isSecure: true, onEditingChanged: { text in
                    print("confirm password changed: \(text)")
                }, onCommit: {
                    print("returned username ehh")
                })
                .frame(maxWidth: Constants.iPadMaxWidth)

                Spacer()
                TermsOfServiceButton(action: {
                    unauthenticatedRouter.route(to: \.terms)
                })

                RoundedInteractiveButton("Set Password", isDisabled: $disableSetPassword, style: .primary, systemImage: nil, action: {

                })
                .padding(.bottom, 10)
            }
        }.navigationBarTitle("Set Password", displayMode: .inline)
    }

}
