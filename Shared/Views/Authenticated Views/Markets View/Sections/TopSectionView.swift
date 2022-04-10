//
//  CategoriesSectionView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 4/8/22.
//

import SwiftUI

struct TopSectionView: View {

    @EnvironmentObject private var marketRouter: MarketsCoordinator.Router

    @ObservedObject private var service: AuthenticatedServices
    @ObservedObject private var store: MarketsService

    init(service: AuthenticatedServices) {
        self.service = service
        self.store = service.market
    }

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            HStack(alignment: .center, spacing: 0) {
                ListSection(style: service.themeStyle) {
                    ListStandardButton(title: "Top Categories", systemImage: "tray.full.fill", isLast: false, style: service.themeStyle, action: {
                        print("Currency")
                        marketRouter.route(to: \.categoriesView)
                    })
                }

                ListSection(style: service.themeStyle) {
                    ListStandardButton(title: "New Listings", systemImage: "tray.full.fill", isLast: false, style: service.themeStyle, action: {
                        print("Currency")
                        marketRouter.route(to: \.categoriesView)
                    })
                }
            }
        }
    }
}
