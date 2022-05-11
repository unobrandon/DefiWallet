//
//  CategoriesDetailView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 5/2/22.
//

import SwiftUI

struct CategoriesDetailView: View {
    @EnvironmentObject private var marketRouter: MarketsCoordinator.Router

    @ObservedObject private var service: AuthenticatedServices
    @ObservedObject private var store: MarketsService
    let category: TokenCategory

    @State private var searchText: String = ""
    @State private var noMore: Bool = false
    @State var showIndicator: Bool = false
    @State private var limitCells: Int = 25

    init(category: TokenCategory, service: AuthenticatedServices) {
        self.category = category
        self.service = service
        self.store = service.market

        self.store.tokenCategoryList.removeAll()
    }

    var body: some View {
        BackgroundColorView(style: service.themeStyle, {
            ScrollView {
                HStack {
                    VStack(alignment: .leading, spacing: 2.5) {
                        if let numCap = category.marketCap,
                           let numVol = category.volume24H {
                            Text("The \(self.category.name ?? "") market cap is \(Locale.current.currencySymbol ?? "")\("".formatLargeNumber(Int(numCap), size: .large)) with a \(Locale.current.currencySymbol ?? "")\("".formatLargeNumber(Int(numVol), size: .large)) 24hr volume.")
                                .fontTemplate(DefaultTemplate.bodySemibold)
                                .multilineTextAlignment(.leading)
                                .padding(.bottom, category.content ?? "" != "" ? 0 : 20)
                        } else if let numCap = category.marketCap {
                            Text("The \(self.category.name ?? "") market cap is \(Locale.current.currencySymbol ?? "")\("".formatLargeNumber(Int(numCap), size: .large)).")
                                .fontTemplate(DefaultTemplate.bodySemibold)
                                .multilineTextAlignment(.leading)
                                .padding(.bottom, category.content ?? "" != "" ? 0 : 20)
                        } else if let numVol = category.volume24H {
                            Text("The \(self.category.name ?? "") 24hr volume is \(Locale.current.currencySymbol ?? "")\("".formatLargeNumber(Int(numVol), size: .large)).")
                                .fontTemplate(DefaultTemplate.bodySemibold)
                                .multilineTextAlignment(.leading)
                                .padding(.bottom, category.content ?? "" != "" ? 0 : 20)
                        }

                        if let content = category.content, !content.isEmpty {
                            ViewMoreText(content)
                        }
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)

                ListSection(style: service.themeStyle) {
                    ForEach(store.tokenCategoryList.prefix(limitCells).indices, id: \.self) { index in
                        TokenListStandardCell(service: service, data: store.tokenCategoryList[index],
                                              isLast: false,
                                              style: service.themeStyle, action: {
                            marketRouter.route(to: \.tokenDetail, store.tokenCategoryList[index])

                            print("the item is: \(store.tokenCategoryList[index].name ?? "no name")")

                            #if os(iOS)
                                HapticFeedback.rigidHapticFeedback()
                            #endif
                        })
                    }
                }

                RefreshFooter(refreshing: $showIndicator, action: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        limitCells += 25
                        withAnimation(.easeInOut) {
                            showIndicator = false
                            noMore = store.tokenCategories.count <= limitCells
                        }
                    }
                }, label: {
                    if noMore {
                        FooterInformation()
                    } else {
                        LoadingView(title: "loading more...")
                    }
                })
                .noMore(noMore)
                .preload(offset: 50)
            }.enableRefresh()
        })
        .navigationBarTitle(category.name ?? "Category List", displayMode: .large)
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .automatic), prompt: "Search tokens...")
        .onAppear {
            DispatchQueue.main.async {
                Tool.hiddenTabBar()
            }

            guard let id = category.id else { return }
            service.market.fetchCategoryDetails(categoryId: id, currency: service.currentUser.currency)
        }
    }

}
