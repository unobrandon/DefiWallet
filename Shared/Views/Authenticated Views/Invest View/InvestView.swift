//
//  InvestView.swift
//  DefiWallet (iOS)
//
//  Created by Brandon Shaw on 2/14/22.
//

import SwiftUI
import Stinsen

struct InvestView: View {

    @ObservedObject private var service: AuthenticatedServices

    @ObservedObject private var store: InvestService

    init(service: AuthenticatedServices) {
        self.service = service
        self.store = service.invest
    }

    var body: some View {
        BackgroundColorView(style: service.themeStyle, {
            ScrollView {
                Text("It's the Invest view!!")
            }
        })
        .navigationTitle("Invest")
    }

}
