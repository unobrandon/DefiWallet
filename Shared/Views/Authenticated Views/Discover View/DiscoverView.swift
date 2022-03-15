//
//  DiscoverView.swift
//  DefiWallet (iOS)
//
//  Created by Brandon Shaw on 2/14/22.
//

import SwiftUI
import Stinsen

struct DiscoverView: View {

    private let service: AuthenticatedServices

    @ObservedObject private var store: DiscoverService

    init(service: AuthenticatedServices) {
        self.service = service
        self.store = service.discover
    }

    var body: some View {
        BaseBackgroundColor(style: service.themeStyle, {
            ScrollView {
                Text("It's the Discover view!!")
            }
        })
        .navigationTitle("Discover")
    }

}
