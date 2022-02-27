//
//  MacCommands.swift
//  DefiWallet (macOS)
//
//  Created by Brandon Shaw on 2/26/22.
//

import SwiftUI

struct AppCommands: Commands {
    var body: some Commands {
        CommandMenu("Wallet") {
            Button("Clear Something") {
                print("some random wallet command")
            }
            .keyboardShortcut("C", modifiers: [.command, .shift])
        }

        // Adds item in the 'View' section
        CommandGroup(replacing: .toolbar) {
            Button("MyApp Help") {
                print("Hello youuu!")
            }
        }

        // Makes own Menu item
        CommandMenu("My Wallet") {
            Button("Print message") {
                print("Hello World!")
            }.keyboardShortcut("p")
        }
    }

}
