//
//  CompleatedView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 3/3/22.
//

import SwiftUI

struct CompletedView: View {

    @EnvironmentObject private var unauthenticatedRouter: UnauthenticatedCoordinator.Router

    @ObservedObject private var store: UnauthenticatedServices

    @State var confettiCounter: Int = 0

    init(services: UnauthenticatedServices) {
        self.store = services
    }

    var body: some View {
        ZStack(alignment: .center) {
            Color("baseBackground").ignoresSafeArea()

            VStack(alignment: .center, spacing: 10) {
                Spacer()

                Button(action: {
                    self.confettiCounter += 1

                    #if os(iOS)
                        HapticFeedback.rigidHapticFeedback()
                    #endif
                }, label: {
                    HeaderIcon(size: 48, imageName: "person.text.rectangle")
                })
                .buttonStyle(ClickInteractiveStyle())
                .padding(.bottom, 10)

                Text("Congratulations!")
                    .fontTemplate(DefaultTemplate.titleSemiBold)
                    .padding(.horizontal)
                    .multilineTextAlignment(.center)
                    .padding(.bottom)

                Text("Your \(Constants.projectName) wallet is now set up. Begin exploring all the possibilities!")
                    .fontTemplate(DefaultTemplate.bodyMono)
                    .frame(maxWidth: Constants.iPadMaxWidth)
                    .multilineTextAlignment(.center)

                Spacer()
                TermsOfServiceButton(action: {
                    unauthenticatedRouter.route(to: \.terms)
                })
                .padding(.bottom, 10)

                RoundedButton("Get Started", style: .primary, systemImage: nil, action: {
                    store.getStarted()
                })
                .padding(.bottom, 30)
            }

            ConfettiCannon(counter: $confettiCounter, repetitions: confettiCounter > 0 ? 1 : 3, repetitionInterval: 0.2)
        }.navigationBarTitle("", displayMode: .inline)
        #if os(iOS)
        .navigationBarBackButtonHidden(true)
        #endif
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                self.confettiCounter += 1

                #if os(iOS)
                    HapticFeedback.successHapticFeedback()
                #endif
            }
        }
    }

}
