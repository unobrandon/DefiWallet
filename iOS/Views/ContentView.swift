//
//  ContentView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/9/22.
//

import SwiftUI

struct ContentView: View {
    private var idiom : UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    
    var body: some View {
        TabView {
            WalletView()
                .tabItem {
                    Label("", systemImage: "wallet.pass")
                }

            WalletView()
                .tabItem {
                    Label("", systemImage: "wallet.pass")
                }

            WalletView()
                .tabItem {
                    Label("", systemImage: "wallet.pass")
                }
            
            WalletView()
                .tabItem {
                    Label("", systemImage: "wallet.pass")
                }

            WalletView()
                .tabItem {
                    Image("AppIcon-Dev")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 34, height: 34, alignment: .center)
                }
        }
    }
}

struct WalletView: View {
    
    var body: some View {
        Text("yes")
    }
}
