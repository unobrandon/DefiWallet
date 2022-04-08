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
    @State private var page: Int = 1
    @State private var limitCells: Int = 10

    init(service: AuthenticatedServices) {
        self.service = service
        self.store = service.market
    }

    var body: some View {
        BackgroundColorView(style: service.themeStyle, {
//            LoadMoreScrollView(enableLoadMore: $enableLoadMore, showIndicator: $showIndicator, onLoadMore: {
//                guard limitCells <= store.tokenCategories.prefix(limitCells).count else {
//                    enableLoadMore = false
//                    showIndicator = true
//                    page += 1
//
//                    return
//                }
//
//                limitCells += 10
//                showIndicator = true
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                    enableLoadMore = true
//                    showIndicator = false
//                }
//            }, {
            ScrollView(showsIndicators: true) {
                VStack(alignment: .center, spacing: 10) {
                    ForEach(store.tokenCategories.indices, id: \.self) { index in
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
                }
            }
            .padding(.vertical)
        })
        .navigationBarTitle("Top Categories", displayMode: .inline)
    }

}
