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
    @State private var limitCells: Int = 25
    @State private var filters: FilterCategories = .marketCapDesc

    init(service: AuthenticatedServices) {
        self.service = service
        self.store = service.market

        service.market.tokenCategories.removeAll()
        self.fetchTokenCategories()
    }

    var body: some View {
        BackgroundColorView(style: service.themeStyle, {
            ScrollView {
                LazyVStack(alignment: .leading) {
                    Text("This is a curated list of categories where tokens have shown relevant utility to the category.")
                        .fontTemplate(DefaultTemplate.bodySemibold)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal)
                        .padding(.vertical, 10)

                    ListSection(title: "\(filters == .marketCapAsc ? "smallest market cap" : filters == .marketCapDesc ? "top market cap" : filters == .gainers ? "top 24hr gainers" : filters == .losers ? "top 24hr losers" : filters == .name ? "names A-Z" : "")", hasPadding: false, style: service.themeStyle) {
                        ForEach(store.tokenCategories.prefix(limitCells).indices, id: \.self) { index in
                            CategoryCell(service: service,
                                         data: store.tokenCategories[index],
                                         index: index,
                                         isLast: false,
                                         style: service.themeStyle, action: {
                                print("the id category going to: \(String(describing: store.tokenCategories[index]))")
                                marketRouter.route(to: \.categoryDetailView, store.tokenCategories[index])

                                #if os(iOS)
                                    HapticFeedback.rigidHapticFeedback()
                                #endif
                            })
                        }
                    }
                    .padding(.horizontal)

                    RefreshFooter(refreshing: $showIndicator, action: {
                        limitCells += 25
                        fetchTokenCategories()
                    }, label: {
                        if noMore {
                            FooterInformation()
                        } else {
                            LoadingView()
                        }
                    })
                    .noMore(noMore)
                    .preload(offset: 50)
                }
            }.enableRefresh()
        })
        .navigationBarTitle("Categories", displayMode: .large)
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .automatic), prompt: "Search categories...", suggestions: {
            ForEach(store.tokenCategories.indices , id: \.self) { index in
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
        })
        .onAppear {
            DispatchQueue.main.async {
                Tool.hiddenTabBar()
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Section {
                        Button {
                            store.tokenCategories.removeAll()
                            withAnimation(.easeInOut) { filters = .gainers }
                            self.limitCells = 25
                            self.fetchTokenCategories()
                        } label: {
                            Label("24hr Gainers", systemImage: filters == .gainers ? "checkmark" : "")
                        }

                        Button {
                            store.tokenCategories.removeAll()
                            withAnimation(.easeInOut) { filters = .losers }
                            self.limitCells = 25
                            self.fetchTokenCategories()
                        } label: {
                            Label("24hr Losers", systemImage: filters == .losers ? "checkmark" : "")
                        }

                        Button {
                            store.tokenCategories.removeAll()
                            withAnimation(.easeInOut) { filters = .name }
                            self.limitCells = 25
                            self.fetchTokenCategories()
                        } label: {
                            Label("Name", systemImage: filters == .name ? "checkmark" : "")
                        }

                        Button {
                            store.tokenCategories.removeAll()
                            withAnimation(.easeInOut) { filters = .marketCapDesc }
                            self.limitCells = 25
                            self.fetchTokenCategories()
                        } label: {
                            Label("Market Cap", systemImage: filters == .marketCapDesc ? "checkmark" : "")
                        }
                    }
                } label: {
                    HStack {
                        Image(systemName: "list.bullet")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 18, height: 18, alignment: .center)
                        Text("Sort")
                    }
                }
                .buttonStyle(.borderless)
                .controlSize(.small)
                .buttonBorderShape(.roundedRectangle)
                .buttonStyle(ClickInteractiveStyle(0.99))
            }
        }
    }

    private func fetchTokenCategories() {
        store.fetchTokenCategories(filter: filters, limit: limitCells, skip: limitCells - 25, completion: {
            print("done fetching categories: \(store.tokenCategories.count) ** \(limitCells)")

            withAnimation(.easeInOut) {
                showIndicator = false
                noMore = store.tokenCategories.count < limitCells
            }
        })
    }

}
