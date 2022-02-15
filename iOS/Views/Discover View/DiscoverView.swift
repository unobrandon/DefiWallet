//
//  DiscoverView.swift
//  DefiWallet (iOS)
//
//  Created by Brandon Shaw on 2/14/22.
//

import SwiftUI
import Stinsen

struct DiscoverView: View {

    @EnvironmentObject private var authenticatedRouter: AuthenticatedCoordinator.Router

    init() {

    }

    var body: some View {
        ScrollView {
            Text("It's the Discover view!!")
        }
        .navigationTitle("Discover")
    }

}
