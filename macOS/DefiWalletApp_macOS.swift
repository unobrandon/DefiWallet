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
        .commands { AppCommands() }

        #if os(macOS)
            Settings { SettingsView() }.windowStyle(HiddenTitleBarWindowStyle())
        #endif

    }
}
