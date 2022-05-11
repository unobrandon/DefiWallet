//
//  CategoriesView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 4/8/22.
//

import SwiftUI
import SwiftUIX

struct CategoriesView: View {

    @EnvironmentObject private var marketRouter: MarketsCoordinator.Router

    @ObservedObject private var service: AuthenticatedServices
    @ObservedObject private var store: MarketsService

    @State private var searchText: String = ""
    @State var showIndicator: Bool = false
    @State private var noMore: Bool = false
    @State private var limitCells: Int = 15
    @State private var filters: FilterCategories = .gainers
    @State private var headerOffsets: (CGFloat, CGFloat) = (0, 0)
    @State private var currentTab: String = "Top Gainers"

    init(service: AuthenticatedServices) {
        self.service = service
        self.store = service.market

        self.fetchTokenCategories()
    }

    var body: some View {
        BackgroundColorView(style: service.themeStyle, {
            ScrollView {
                LazyVStack(pinnedViews: [.sectionHeaders]) {
                    Section {
                        ListSection(hasPadding: false, style: service.themeStyle) {
                            ForEach(store.tokenCategories.prefix(limitCells).indices, id: \.self) { index in
                                CategoryCell(service: service,
                                             data: store.tokenCategories[index],
                                             index: index,
                                             isLast: false,
                                             style: service.themeStyle, action: {
                                    marketRouter.route(to: \.categoryDetailView, store.tokenCategories[index])

                                    #if os(iOS)
                                        HapticFeedback.rigidHapticFeedback()
                                    #endif
                                })
                            }
                        }
                        .padding([.horizontal, .top])

                        RefreshFooter(refreshing: $showIndicator, action: {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                limitCells += 15
                                withAnimation(.easeInOut) {
                                    showIndicator = false
                                    noMore = store.tokenCategories.count <= limitCells
                                }
                            }
                        }, label: {
                            if noMore {
                                FooterInformation()
                            } else {
                                LoadingView()
                            }
                        })
                        .noMore(noMore)
                        .preload(offset: 50)
                    } header: {
                        PinnedHeaderView(currentType: $currentTab, sections: ["Top Gainers", "Top Losers", "Market Cap", "Name"], style: service.themeStyle, action: { tapped in
                            if tapped == "Top Gainers" { withAnimation(.easeInOut) { filters = .gainers }
                            } else if tapped == "Top Losers" { withAnimation(.easeInOut) { filters = .losers }
                            } else if tapped == "Market Cap" { withAnimation(.easeInOut) { filters = .marketCap }
                            } else if tapped == "Name" { withAnimation(.easeInOut) { filters = .name }}

                            DispatchQueue.main.async {
                                fetchTokenCategories()
                            }
                        })
                        .offset(y: headerOffsets.1 > 0 ? 0 : -headerOffsets.1 / 8)
                        .modifier(PinnedHeaderOffsetModifier(offset: $headerOffsets.0, returnFromStart: false))
                        .modifier(PinnedHeaderOffsetModifier(offset: $headerOffsets.1))
                    }
                }
            }.enableRefresh()
        })
        .navigationBarTitle("Top Categories", displayMode: .inline)
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .automatic), prompt: "Search categories...")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Section {
                        Button {
                            withAnimation(.easeInOut) { filters = .gainers }
                            self.fetchTokenCategories()
                        } label: {
                            Label("24hr Gainers", systemImage: filters == .gainers ? "checkmark" : "")
                        }

                        Button {
                            withAnimation(.easeInOut) { filters = .losers }
                            self.fetchTokenCategories()
                        } label: {
                            Label("24hr Losers", systemImage: filters == .losers ? "checkmark" : "")
                        }

                        Button {
                            withAnimation(.easeInOut) { filters = .name }
                            self.fetchTokenCategories()
                        } label: {
                            Label("Name", systemImage: filters == .name ? "checkmark" : "")
                        }

                        Button {
                            withAnimation(.easeInOut) { filters = .marketCap }
                            self.fetchTokenCategories()
                        } label: {
                            Label("Market Cap", systemImage: filters == .marketCap ? "checkmark" : "")
                        }
                    }
                } label: {
                    Image(systemName: "slider.horizontal.3")
                }.foregroundColor(Color.primary)
            }
        }
        .onAppear {
            DispatchQueue.main.async {
                Tool.hiddenTabBar()
            }
        }
    }

    private func fetchTokenCategories() {
        store.fetchTokenCategories(filter: filters, completion: {
            print("done fetching categories")
        })
    }

}
