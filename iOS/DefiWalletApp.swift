//
//  DefiWalletApp.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/9/22.
//

import SwiftUI
import Stinsen
import RealmSwift

@main
struct DefiWalletApp: SwiftUI.App {
    var body: some Scene {
        WindowGroup {
            MainCoordinator().view()
                .environment(\.realmConfiguration, Realm.Configuration())
        }
    }
}
