//
//  ContentView.swift
//  DefiWallet (macOS)
//
//  Created by Brandon Shaw on 2/9/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var general = GeneralViewModel()

    var body: some View {
        HStack(spacing: 0) {
            SideNavigationBar(general: general)

            ZStack {
                switch general.selectedTab {
                case "Wallet": Text("Wallet")
                case "Discover": Text("Discover")
                case "Markets": Text("Markets")
                case "Swap": Text("Swap")
                case "Dapps": Text("Dapps")
                case "Settings": Text("Settings")
                default : Text("")
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .animation(.none)
        }
        .ignoresSafeArea(.all, edges: .all)
        .frame(maxWidth: macConstants.screenWidth / 1.2, maxHeight: macConstants.screenWidth - 60)
        .frame(minWidth: 650, minHeight: 450)
        .frame(idealWidth: 1200, idealHeight: 950)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
