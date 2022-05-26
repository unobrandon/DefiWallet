//
//  DiscoverCoordinator+Factory.swift
//  DefiWallet (iOS)
//
//  Created by Brandon Shaw on 2/14/22.
//

import SwiftUI
import Stinsen

extension DiscoverCoordinator {

    @ViewBuilder func makeStart() -> some View {
        DiscoverView(service: services)
    }

}
