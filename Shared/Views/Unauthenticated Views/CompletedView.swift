//
//  CompleatedView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 3/3/22.
//

import SwiftUI

struct CompletedView: View {

    @EnvironmentObject private var unauthenticatedRouter: UnauthenticatedCoordinator.Router

    @ObservedObject private var store: UserOnboardingServices

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

                Text("Congrats!")
                    .fontTemplate(DefaultTemplate.subheadingBold)
                    .padding(.horizontal)
                    .multilineTextAlignment(.center)

                Text("Your \(Constants.projectName) wallet is fully set up. You can begin to explore all the possibilities.")
                    .fontTemplate(DefaultTemplate.bodySemibold)
                    .padding(.horizontal)
                    .multilineTextAlignment(.center)

                Spacer()
                RoundedButton("Get Started", style: .primary, systemImage: nil, action: {

                })
                .padding(.bottom, 10)
            }
        }.navigationBarTitle("", displayMode: .inline)
    }

}
