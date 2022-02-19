//
//  macSideNavidationBar.swift
//  DefiWallet (macOS)
//
//  Created by Brandon Shaw on 2/10/22.
//

import SwiftUI
import Stinsen

struct SideNavigationBar: View {

    @ObservedObject var services: AuthenticatedServices

    @EnvironmentObject private var macauthenticatedRouter: MacAuthenticatedCoordinator.Router

    init(services: AuthenticatedServices) {
        self.services = services
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .center, spacing: 10) {
                Circle()
                    .frame(width: 34, height: 34)
                    .foregroundColor(.secondary)

                VStack(alignment: .leading) {
                    Text("0xf43...fB6a")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    Text("@unobrandon")
                        .font(.headline)
                        .foregroundColor(.primary)
                }.fixedSize()
            }
            .padding(.horizontal)
            .padding(.top, 10)

            Divider()
                .padding(.vertical, 10)

            ScrollView(.vertical, showsIndicators: false) {
                TabBarButton(image: "folder", title: "Wallet", services: services, action: {
                    services.macTabStatus = .wallet
                })

                TabBarButton(image: "chart.bar.xaxis", title: "Markets", services: services, action: {
                    services.macTabStatus = .markets
                })

                TabBarButton(image: "safari", title: "Discover", services: services, action: {
                    services.macTabStatus = .discover
                })

                TabBarButton(image: "leaf", title: "Invest", services: services, action: {
                    services.macTabStatus = .invest
                })

                TabBarButton(image: "app.badge", title: "Dapps", services: services, action: {
                    services.macTabStatus = .profile
                })
            }
            .padding(.horizontal)

            Divider()
            TabBarButton(image: "gear", title: "Settings", services: services, action: {
                services.macTabStatus = .profile
            })
                .padding(.horizontal)
                .padding(.bottom)
                .padding(.top, 5)
        }
    }
}
