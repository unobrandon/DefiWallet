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

    init(services: UnauthenticatedServices) {
        self.store = services.userOnboarding
    }

    var body: some View {
        ZStack(alignment: .center) {
            Color("baseBackground").ignoresSafeArea()

            VStack(alignment: .center, spacing: 20) {
                Spacer()

                TextFieldSingleBordered(text: "", placeholder: "password", systemImage: "lock.shield", textLimit: 20, onEditingChanged: { text in
                    print("text changed: \(text)")
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
