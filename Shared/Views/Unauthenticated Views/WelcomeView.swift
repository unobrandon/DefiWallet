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

    var body: some View {
        NavigationView {
            GeometryReader { geo in
                VStack(alignment: .center, spacing: 20) {
                    MainCarouselView()

                    VStack(alignment: .center, spacing: 20) {
                        RoundedButton("Create Wallet", style: .primary, systemImage: "paperplane.fill", action: {
                            unauthenticatedRouter.route(to: \.createWallet)
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
                    .background(bottomGradientView(geo))
                }.background(ColorfulView(colors: [.red, .pink, .purple, .blue]))
            }
        }
        #if os(iOS)
        .navigationViewStyle(StackNavigationViewStyle())
        #endif
    }

    @ViewBuilder
    func bottomGradientView(_ proxy: GeometryProxy) -> some View {
        Rectangle().fill(
            LinearGradient(gradient: Gradient(stops: [
                .init(color: DefaultTemplates.systemBackgroundColor.opacity(0.01), location: 0),
                .init(color: DefaultTemplates.systemBackgroundColor, location: 1)
                ]), startPoint: .top, endPoint: .bottom)
            ).frame(width: proxy.size.width, height: 140)
            .frame(maxWidth: .infinity, alignment: .center)
            .offset(y: 20)
            .edgesIgnoringSafeArea(.vertical)
    }

}
