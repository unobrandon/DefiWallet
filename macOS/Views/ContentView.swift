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
                // Note: Can not set 'min/maxWidth'. Set it in the content view.
                SideNavigationBar(general: general)

                ZStack {
                    switch general.selectedTab {
                    case "Wallet": Text("Wallet").navigationTitle("Wallet").frame(minWidth: 450)
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
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Button(action: toggleSidebar, label: {
                        Image(systemName: "sidebar.leading")
                    })
                }
            }
        }
        .ignoresSafeArea(.all, edges: .all)
        .frame(maxWidth: MacConstants.screenWidth / 1.5, maxHeight: MacConstants.screenHeight / 1.5)
        .frame(minWidth: 650, minHeight: 200)
        .frame(idealWidth: 1050, idealHeight: 950)
    }

    private func toggleSidebar() {
        NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
