//
//  CategoriesSectionView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 4/8/22.
//

import SwiftUI

struct CategoriesSectionView: View {

    @EnvironmentObject private var marketRouter: MarketsCoordinator.Router

    @ObservedObject private var service: AuthenticatedServices
    @ObservedObject private var store: MarketsService

    init(service: AuthenticatedServices) {
        self.service = service
        self.store = service.market
    }

    var body: some View {
        ListSection(style: service.themeStyle) {
            ListStandardButton(title: "Categories", systemImage: "tray.full.fill", isLast: false, style: service.themeStyle, action: {
                print("Currency")
                marketRouter.route(to: \.categoriesView)
            })
        }
    }
}
