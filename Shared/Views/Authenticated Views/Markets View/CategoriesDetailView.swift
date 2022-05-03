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
    @State var enableLoadMore: Bool = true
    @State var showIndicator: Bool = false
    @State private var expanded: Bool = false
    @State private var truncated: Bool = false
    @State private var limitCells: Int = 25

    init(category: TokenCategory, service: AuthenticatedServices) {
        self.category = category
        self.service = service
        self.store = service.market

        self.store.tokenCategoryList.removeAll()
    }

    var body: some View {
        BackgroundColorView(style: service.themeStyle, {
            LoadMoreScrollView(enableLoadMore: $enableLoadMore, showIndicator: $showIndicator, onLoadMore: {
                guard limitCells <= store.tokenCategories.count else {
                    enableLoadMore = false
                    showIndicator = false

                    return
                }

                limitCells += 25
                showIndicator = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    enableLoadMore = true
                    showIndicator = false
                }
            }, {
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
                            Text(content)
                                .fontTemplate(DefaultTemplate.caption)
                                .multilineTextAlignment(.leading)
                                .lineLimit(expanded ? nil : 3)
                                .background(
                                    Text(content).lineLimit(3)
                                        .background(GeometryReader { displayedGeometry in
                                            ZStack {
                                                Text(content)
                                                    .background(GeometryReader { fullGeometry in
                                                        Color.clear.onAppear {
                                                            self.truncated = fullGeometry.size.height > displayedGeometry.size.height
                                                        }
                                                    })
                                            }
                                            .frame(height: .greatestFiniteMagnitude)
                                        })
                                        .hidden() // Hide the background
                                )
                                .padding(.top, 5)
                                .padding(.bottom, truncated ? 0 : 5)

                            if truncated { toggleButton.padding(.bottom, 5) }
                        }
                    }
                    Spacer()
                }
                .padding(.horizontal, 30)
                .padding(.vertical, 10)

                ListSection(style: service.themeStyle) {
                    ForEach(store.tokenCategoryList.prefix(limitCells).indices, id: \.self) { index in
                        TokenListStandardCell(service: service, data: store.tokenCategoryList[index],
                                              isLast: false,
                                              style: service.themeStyle, action: {
    //                        walletRouter.route(to: \.historyDetail, item)
                            print("the item is: \(store.tokenCategoryList[index].name ?? "no name")")

                            #if os(iOS)
                                HapticFeedback.rigidHapticFeedback()
                            #endif
                        })
                    }
                }
            })
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

    var toggleButton: some View {
        Button(action: {
            withAnimation(.easeOut) {
                self.expanded.toggle()
            }
        }, label: {
            Text(self.expanded ? "Show less" : "Show more").font(.caption)
        })
    }

}
