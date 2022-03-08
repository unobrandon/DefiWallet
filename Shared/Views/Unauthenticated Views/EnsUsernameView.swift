//
//  EnsUsernameView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/28/22.
//

import SwiftUI

struct EnsUsernameView: View {

    @EnvironmentObject private var unauthenticatedRouter: UnauthenticatedCoordinator.Router

    @ObservedObject private var store: UnauthenticatedServices

    @State var disablePrimaryAction: Bool = true

    init(services: UnauthenticatedServices) {
        self.store = services
    }

    var body: some View {
        ZStack(alignment: .center) {
            Color("baseBackground").ignoresSafeArea()

            VStack(alignment: .center, spacing: 10) {
                Spacer()

                HeaderIcon(size: 48, imageName: "person.text.rectangle")
                    .padding(.bottom, 10)

                Text("Universal username")
                    .fontTemplate(DefaultTemplate.headingSemiBold)
                    .multilineTextAlignment(.center)

                Text("Change your crazy long wallet address to a readable username.")
                    .fontTemplate(DefaultTemplate.bodyMono_secondary)
                    .multilineTextAlignment(.center)

                Spacer()
                TextFieldSingleBordered(text: "", placeholder: "username.deifiwallet.eth", systemImage: "person.crop.circle", textLimit: 20, onEditingChanged: { text in
                    print("text changed: \(text)")
                }, onCommit: {
                    print("returned username ehh")
                })
                .frame(maxWidth: Constants.iPadMaxWidth)

                Spacer()
                Text("powered by Ethereum Name Service")
                    .fontTemplate(DefaultTemplate.caption)
                    .padding(.bottom, 10)

                RoundedInteractiveButton("Set Username", isDisabled: $disablePrimaryAction, style: .primary, systemImage: nil, action: {
                    unauthenticatedRouter.route(to: \.ensAvatar)
                })
                .padding(.bottom, 30)
            }.padding(.horizontal)
        }.navigationBarTitle("ENS Domain Name", displayMode: .inline)
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
//                    unauthenticatedRouter.route(to: \.notifications)

                    #if os(iOS)
                        HapticFeedback.lightHapticFeedback()
                    #endif
                }, label: Text("skip").foregroundColor(.secondary))
            }
        }
    }

}
