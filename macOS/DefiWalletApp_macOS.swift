//
//  DefiWallet__macOS_App.swift
//  DefiWallet (macOS)
//
//  Created by Brandon Shaw on 2/9/22.
//

import SwiftUI

@main
struct DefiWalletApp_macOS: App {

    @NSApplicationDelegateAdaptor(macAppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .background(macBlurView())
                .onReceive(NotificationCenter.default.publisher(for: NSApplication.willUpdateNotification), perform: { _ in
                    // disable the full screen button
                    for window in NSApplication.shared.windows {
                        window.standardWindowButton(.zoomButton)?.isEnabled = false
                    }
                })
        }
        .windowStyle(HiddenTitleBarWindowStyle())
    }
}

class macAppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    var popOver = NSPopover()

    func applicationDidFinishLaunching(_ notification: Notification) {
        let menuView = StatusBar()
        
        popOver.behavior = .transient
        popOver.animates = false

        popOver.contentViewController = NSViewController()
        popOver.contentViewController?.view = NSHostingView(rootView: menuView)
        
        popOver.contentViewController?.view.window?.makeKey()
        
        // creating status bar button....
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        // Safe Check if status Button is Available or not...
        if let menuButton = statusItem?.button {
            menuButton.image = NSImage(systemSymbolName: "icloud.and.arrow.up.fill", accessibilityDescription: nil)
            menuButton.action = #selector(StatusBarButtonToggle)
        }
    }

    @objc func StatusBarButtonToggle(sender: AnyObject) {
        guard !popOver.isShown, let menuButton = statusItem?.button else {
            popOver.performClose(sender)
            
            return
        }

        self.popOver.show(relativeTo: menuButton.bounds, of: menuButton, preferredEdge: NSRectEdge.minY)
    }
}
