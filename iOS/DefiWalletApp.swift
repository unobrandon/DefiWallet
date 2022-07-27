//
//  DefiWalletApp.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/9/22.
//

import SwiftUI
import Stinsen

@available(iOS 14.0, *)
struct DefiWalletApp: App {

    @UIApplicationDelegateAdaptor(IOSAppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            MainCoordinator().view()
        }
    }
}
