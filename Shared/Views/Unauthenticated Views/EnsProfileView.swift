//
//  EnsUsernameView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/28/22.
//

import SwiftUI

struct EnsProfileView: View {

    @EnvironmentObject private var unauthenticatedRouter: UnauthenticatedCoordinator.Router

    @ObservedObject private var store: UnauthenticatedServices

    @State var disablePrimaryAction: Bool = true

    init(services: UnauthenticatedServices) {
        self.store = services
    }

    var body: some View {
        ZStack(alignment: .center) {
            Color("baseBackground").ignoresSafeArea()

            VStack(alignment: .center, spacing: 0) {
                Spacer()

                HeaderIcon(size: 48, imageName: "person.text.rectangle")
                    .padding(.bottom)

                Text("Universal\nusername & avatar")
                    .fontTemplate(DefaultTemplate.titleSemibold)
                    .multilineTextAlignment(.center)
                    .padding(.bottom)

                Text("Change your crazy long wallet address to a readable username.")
                    .fontTemplate(DefaultTemplate.bodyBold)
                    .multilineTextAlignment(.center)

                Spacer()
                TextFieldSingleBordered(text: "", placeholder: "username", systemImage: "person.crop.circle", textLimit: 20, onEditingChanged: { text in
                    print("text changed: \(text)")
                }, onCommit: {
                    print("returned username ehh")
                })
                .frame(maxWidth: Constants.iPadMaxWidth)

                Spacer()
                Text("powered by Ethereum Name Service")
                    .fontTemplate(DefaultTemplate.caption)
                    .padding(.bottom, 10)

                RoundedInteractiveButton("Set Profile", isDisabled: $disablePrimaryAction, style: .primary, systemImage: nil, action: {

                })
                .padding(.bottom)
            }.padding(.horizontal)
        }.navigationBarTitle("ENS Profile", displayMode: .inline)
        #if os(iOS)
        .navigationBarBackButtonHidden(true)
        #endif
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    store.checkNotificationPermission(completion: { isEnabled in
                        if isEnabled {
                            unauthenticatedRouter.route(to: \.completed)
                        } else {
                            unauthenticatedRouter.route(to: \.notifications)
                        }
                    })

                    #if os(iOS)
                        HapticFeedback.lightHapticFeedback()
                    #endif
                }, label: Text("skip").foregroundColor(.secondary))
            }
        }
    }

}
