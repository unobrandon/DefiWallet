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

                OnboardingHeaderView(imageName: "bell.fill",
                                     title: "Enable notifications",
                                     subtitle: "Receive push notifications for price alerts and wallet activity.")

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
            }
        }.navigationBarTitle("Enable Notifications", displayMode: .inline)
        #if os(iOS)
        .navigationBarBackButtonHidden(true)
        #endif
    }

}
