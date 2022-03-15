//
//  MarketsView.swift
//  DefiWallet (iOS)
//
//  Created by Brandon Shaw on 2/14/22.
//

import SwiftUI
import Stinsen

struct MarketsView: View {

    @ObservedObject private var service: AuthenticatedServices

    @ObservedObject private var store: MarketsService

    init(service: AuthenticatedServices) {
        self.service = service
        self.store = service.market
    }

    var body: some View {
        BackgroundColorView(style: service.themeStyle, {
            ScrollView {
                Text("It's the market view!!")
            }
        })
        .navigationTitle("Market")
    }

}
