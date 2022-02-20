//
//  InvestView.swift
//  DefiWallet (iOS)
//
//  Created by Brandon Shaw on 2/14/22.
//

import SwiftUI
import Stinsen

struct InvestView: View {

    private let services: AuthenticatedServices

    @ObservedObject private var store: InvestService

    init(services: AuthenticatedServices) {
        self.services = services
        self.store = services.invest
    }

    var body: some View {
        ScrollView {
            Text("It's the Investment view!!")
        }
        .navigationTitle("Invest")
    }

}
