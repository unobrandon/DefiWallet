//
//  NotiPermissionsView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 3/5/22.
//

import SwiftUI

struct NotiPermissionsView: View {

    @EnvironmentObject private var unauthenticatedRouter: UnauthenticatedCoordinator.Router

    @ObservedObject private var store: UnauthenticatedServices

    init(services: UnauthenticatedServices) {
        self.store = services
    }

    var body: some View {
        ZStack(alignment: .center) {
            Color("baseBackground").ignoresSafeArea()

            VStack(alignment: .center, spacing: 10) {
                Spacer()

                HeaderIcon(size: 48, imageName: "bell.fill")
                    .padding(.bottom, 10)

                Text("Enable notifications")
                    .fontTemplate(DefaultTemplate.headingSemiBold)
                    .multilineTextAlignment(.center)

                Text("Receive push notifications for price alerts and wallet activity.")
                    .fontTemplate(DefaultTemplate.bodyMono_secondary)
                    .multilineTextAlignment(.center)

                Spacer()

                NotificationBanner(style: .border, onSuccess: {
                    unauthenticatedRouter.route(to: \.completed)
                })
                .frame(maxWidth: Constants.iPadMaxWidth)

                Spacer()
                RoundedButton("Next", style: .primary, systemImage: nil, action: {
                    unauthenticatedRouter.route(to: \.completed)
                })
                .padding(.bottom, 30)
            }.padding(.horizontal)
        }.navigationBarTitle("Enable Notifications", displayMode: .inline)
        #if os(iOS)
        .navigationBarBackButtonHidden(true)
        #endif
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
