//
//  DefiWallet__macOS_App.swift
//  DefiWallet (macOS)
//
//  Created by Brandon Shaw on 2/9/22.
//

import SwiftUI
import Stinsen

@main
struct DefiWalletApp_macOS: App {

    @NSApplicationDelegateAdaptor(MacAppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            MainCoordinator().view()
                .onReceive(NotificationCenter.default.publisher(for: NSApplication.willUpdateNotification),
                           perform: { _ in
                    // disable the full screen button
                    for window in NSApplication.shared.windows {
                        window.standardWindowButton(.zoomButton)?.isEnabled = false
                    }
                })
        }
//        .windowStyle(HiddenTitleBarWindowStyle())
        .commands(content: {
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
        })
    }
}
