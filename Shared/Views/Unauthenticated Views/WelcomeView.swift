//
//  WelcomeView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/13/22.
//

import SwiftUI
import Stinsen
import Colorful

struct WelcomeView: View {

    @EnvironmentObject private var unauthenticatedRouter: UnauthenticatedCoordinator.Router

    @ObservedObject private var store: UnauthenticatedServices

    @State var showSheet: Bool = false

    init(services: UnauthenticatedServices) {
        self.store = services
    }

    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .center, spacing: 10) {
                MainCarouselView()

                VStack(alignment: .center, spacing: 20) {
                    RoundedButton("Create New Wallet", style: .primary, systemImage: "paperplane.fill", action: {
                        guard store.unauthenticatedWallet.address == "" else {
                            showSheet.toggle()
                            return
                        }

                        unauthenticatedRouter.route(to: \.generateWallet)
                        #if os(iOS)
                            HapticFeedback.rigidHapticFeedback()
                        #endif
                    })

                    Button("Import Wallet") {
                        unauthenticatedRouter.route(to: \.importWallet)
                        #if os(iOS)
                            HapticFeedback.lightHapticFeedback()
                        #endif
                    }
                    .padding(.bottom)
                }
                .padding(.horizontal)
                .background(bottomGradientView(geo))
            }.background(ColorfulView(animation: Animation.easeInOut(duration: 10), colors: [.red, .pink, .purple, .blue]))
                .confirmationDialog("We notice you have generated \(store.unauthenticatedWallet.name).\nKeep current address or generate a new address?",
                                isPresented: $showSheet,
                                titleVisibility: .visible) {
                Button("Continue") {
                    unauthenticatedRouter.route(to: \.privateKeys)
                }

                Button("New Wallet", role: .destructive) {
                    store.unauthenticatedWallet = Wallet(address: "", data: Data(), name: "", isHD: true)
                    unauthenticatedRouter.route(to: \.generateWallet)

                    #if os(iOS)
                        HapticFeedback.rigidHapticFeedback()
                    #endif
                }
            }
        }.background(AppGradients.purpleGradient)
        #if os(iOS)
        .navigationViewStyle(StackNavigationViewStyle())
        #endif
    }

    @ViewBuilder
    func bottomGradientView(_ proxy: GeometryProxy) -> some View {
        Rectangle().fill(AppGradients.backgroundFade)
            .frame(width: proxy.size.width, height: 140)
            .frame(maxWidth: .infinity, alignment: .center)
            .offset(y: 20)
            .edgesIgnoringSafeArea(.vertical)
    }

}
