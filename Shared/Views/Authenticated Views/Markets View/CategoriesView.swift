//
//  CategoriesView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 4/8/22.
//

import SwiftUI

struct CategoriesView: View {

    @EnvironmentObject private var marketRouter: MarketsCoordinator.Router

    @ObservedObject private var service: AuthenticatedServices
    @ObservedObject private var store: MarketsService

    @State var enableLoadMore: Bool = true
    @State var showIndicator: Bool = false
    @State private var limitCells: Int = 10

    init(service: AuthenticatedServices) {
        self.service = service
        self.store = service.market
    }

    var body: some View {
        BackgroundColorView(style: service.themeStyle, {
            LoadMoreScrollView(enableLoadMore: $enableLoadMore, showIndicator: $showIndicator, onLoadMore: {
                guard limitCells <= store.tokenCategories.count else {
                    enableLoadMore = false
                    showIndicator = false

                    return
                }

                limitCells += 10
                showIndicator = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    enableLoadMore = true
                    showIndicator = false
                }
            }, {
                ForEach(store.tokenCategories.prefix(limitCells).indices, id: \.self) { index in
                    ListSection(style: service.themeStyle) {
                            CategoryCell(service: service,
                                         data: store.tokenCategories[index],
                                         index: index,
                                         isLast: false,
                                         style: service.themeStyle, action: {
                                print("categories details")
    //                            marketRouter.route(to: \.historyDetail, item)
                            })
                    }
                }
            })
        })
        .navigationBarTitle("Categories", displayMode: .inline)
    }

}