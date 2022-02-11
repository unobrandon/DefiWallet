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
        if UIDevice.current.userInterfaceIdiom == .pad {
            ZStack {
                NavigationView {
                    Text("Hello, world!")
                        .padding()
                }
                
                Text("Hello, world!222")
                    .padding()
            }
        } else if UIDevice.current.userInterfaceIdiom == .phone {
            NavigationView {
                Text("Hello, iPhone!")
                    .padding()
            }
        }
    }
}
