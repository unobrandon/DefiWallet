//
//  MarketsView.swift
//  DefiWallet (iOS)
//
//  Created by Brandon Shaw on 2/14/22.
//

import SwiftUI
import Stinsen

struct MarketsView: View {

    @EnvironmentObject private var authenticatedRouter: AuthenticatedCoordinator.Router

    init() {
        print("markets view did inittt")
    }

    var body: some View {
        ScrollView {
            Text("It's the market view!!")
        }
        .navigationTitle("Market")
    }

}
