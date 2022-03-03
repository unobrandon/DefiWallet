//
//  EnsUsernameView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/28/22.
//

import SwiftUI

struct EnsProfileView: View {

    @EnvironmentObject private var unauthenticatedRouter: UnauthenticatedCoordinator.Router

    @ObservedObject private var store: UserOnboardingServices

    @State var disablePrimaryAction: Bool = true

    init(services: UnauthenticatedServices) {
        self.store = services.userOnboarding
    }

    var body: some View {
        ZStack(alignment: .center) {
            Color("baseBackground").ignoresSafeArea()

            VStack(alignment: .center, spacing: 20) {
                Spacer()

                HeaderIcon(size: 48, imageName: "person.text.rectangle")
                    .padding(.bottom)

                Text("Lets set up a universal username & avatar")
                    .fontTemplate(DefaultTemplate.subheadingBold)
                    .padding(.horizontal)
                    .multilineTextAlignment(.center)

                Spacer()
                TextFieldSingleBordered(text: "", placeholder: "username", systemImage: "person.crop.circle", textLimit: 20, onEditingChanged: { text in
                    print("text changed: \(text)")
                }, onCommit: {
                    print("returned username ehh")
                })
                .frame(maxWidth: Constants.iPadMaxWidth)

                Spacer()
                RoundedInteractiveButton("Set Profile", isDisabled: $disablePrimaryAction, style: .primary, systemImage: nil, action: {

                })
                .padding(.bottom, 10)
            }
        }.navigationBarTitle("ENS Profile", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    unauthenticatedRouter.route(to: \.completed)
                    #if os(iOS)
                        HapticFeedback.lightHapticFeedback()
                    #endif
                }, label: Text("skip").foregroundColor(.secondary))
            }
        }
    }

}
