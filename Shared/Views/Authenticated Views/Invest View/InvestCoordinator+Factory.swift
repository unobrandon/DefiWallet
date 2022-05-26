//
//  InvestCoordinator+Factory.swift
//  DefiWallet (iOS)
//
//  Created by Brandon Shaw on 2/14/22.
//

import SwiftUI
import Stinsen

extension InvestCoordinator {

    @ViewBuilder func makeStart() -> some View {
        InvestView(service: services)
    }

}
