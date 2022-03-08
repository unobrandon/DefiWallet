//
//  DiscoverView.swift
//  DefiWallet (iOS)
//
//  Created by Brandon Shaw on 2/14/22.
//

import SwiftUI
import Stinsen

struct DiscoverView: View {

    @ObservedObject private var store: DiscoverService

    init(service: AuthenticatedServices) {
        self.store = service.discover
    }

    var body: some View {
        ZStack {
            Color("baseBackground").ignoresSafeArea()

            ScrollView {
                Text("It's the Discover view!!")
            }
        }
        .navigationTitle("Discover")
    }

}
