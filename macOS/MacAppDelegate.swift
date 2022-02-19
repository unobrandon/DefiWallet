//
//  MacAppDelegate.swift
//  DefiWallet (macOS)
//
//  Created by Brandon Shaw on 2/19/22.
//

import SwiftUI

class MacAppDelegate: NSObject, NSApplicationDelegate {
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

        // Safe check if status bar button is available or not
        if let menuButton = statusItem?.button {
            menuButton.image = NSImage(systemSymbolName: "icloud.and.arrow.up.fill", accessibilityDescription: nil)
            menuButton.action = #selector(statusBarToggle)
        }
    }

    @objc func statusBarToggle(sender: AnyObject) {
        guard !popOver.isShown, let menuButton = statusItem?.button else {
            popOver.performClose(sender)

            return
        }

        self.popOver.show(relativeTo: menuButton.bounds, of: menuButton, preferredEdge: NSRectEdge.minY)
    }

}
