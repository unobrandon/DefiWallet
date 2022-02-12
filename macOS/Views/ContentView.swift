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
            NavigationView {
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
                .background(Color("bgColor"))
                .animation(.none)
            }
        }
        .ignoresSafeArea(.all, edges: .all)
        .frame(maxWidth: macConstants.screenWidth / 1.5, maxHeight: macConstants.screenHeight / 1.5)
        .frame(minWidth: 650, minHeight: 450)
        .frame(idealWidth: 1050, idealHeight: 950)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
