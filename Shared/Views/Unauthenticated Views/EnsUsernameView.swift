//
//  EnsUsernameView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/28/22.
//

import SwiftUI

struct EnsUsernameView: View {

    @EnvironmentObject private var unauthenticatedRouter: UnauthenticatedCoordinator.Router

    @ObservedObject private var store: UserOnboardingServices

    @State var disableSetUsername: Bool = true

    init(services: UnauthenticatedServices) {
        self.store = services.userOnboarding
    }

    var body: some View {
        ZStack(alignment: .center) {
            Color("baseBackground").ignoresSafeArea()

            VStack(alignment: .center, spacing: 20) {
                Spacer()

                TextFieldSingleBordered(text: "", placeholder: "username", systemImage: "person.crop.circle", textLimit: 20, onEditingChanged: { text in
                    print("text changed: \(text)")
                }, onCommit: {
                    print("returned username ehh")
                })
                .frame(maxWidth: Constants.iPadMaxWidth)

                Spacer()
                RoundedInteractiveButton("Set Username", isDisabled: $disableSetUsername, style: .primary, systemImage: nil, action: {

                })
                .padding(.bottom, 10)
            }
        }.navigationBarTitle("ENS Username", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
//                    unauthenticatedRouter.route(to: \.importWallet)
                    #if os(iOS)
                        HapticFeedback.lightHapticFeedback()
                    #endif
                }, label: Text("skip").foregroundColor(.secondary))
            }
        }
    }

}
