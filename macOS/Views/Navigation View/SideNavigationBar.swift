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
            
            Divider().frame(width: 100)
                .padding(.top, 10)

            TabBarButton(image: "folder", title: "Wallet", selectedTab: $general.selectedTab)
                .padding(.top)
            
            TabBarButton(image: "safari", title: "Discover", selectedTab: $general.selectedTab)
            
            TabBarButton(image: "chart.bar.xaxis", title: "Markets", selectedTab: $general.selectedTab)
            
            TabBarButton(image: "arrow.triangle.swap", title: "Swap", selectedTab: $general.selectedTab)

            TabBarButton(image: "app.badge", title: "Dapps", selectedTab: $general.selectedTab)

            Spacer()
            TabBarButton(image: "gear", title: "Settings", selectedTab: $general.selectedTab)
        }
        .padding()
        .padding(.top, 35)
        .background(macBlurView())
    }
}
