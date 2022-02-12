//
//  macSideNavidationBar.swift
//  DefiWallet (macOS)
//
//  Created by Brandon Shaw on 2/10/22.
//

import SwiftUI

struct SideNavigationBar: View {
    @StateObject var general: GeneralViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
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
                }
            }
            .padding(.horizontal)
            .padding(.top, 10)

            Divider()
                .padding(.top, 5)
                .padding(.leading)

            List {
                TabBarButton(image: "folder", title: "Wallet", selectedTab: $general.selectedTab)

                TabBarButton(image: "safari", title: "Discover", selectedTab: $general.selectedTab)

                TabBarButton(image: "chart.bar.xaxis", title: "Markets", selectedTab: $general.selectedTab)

                TabBarButton(image: "arrow.triangle.swap", title: "Swap", selectedTab: $general.selectedTab)

                TabBarButton(image: "app.badge", title: "Dapps", selectedTab: $general.selectedTab)
            }
            .listStyle(.sidebar)
            .padding(.top, 5)

            Spacer()
            Divider().padding(.leading)
            TabBarButton(image: "gear", title: "Settings", selectedTab: $general.selectedTab)
                .padding(.horizontal)
                .padding(.bottom)
        }
    }
}
