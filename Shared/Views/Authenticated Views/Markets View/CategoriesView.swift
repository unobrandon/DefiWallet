//
//  CategoriesView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 4/8/22.
//

import SwiftUI
import SwiftUIX
import Combine
import Alamofire

struct CategoriesView: View {

    @EnvironmentObject private var marketRouter: MarketsCoordinator.Router

    @ObservedObject private var service: AuthenticatedServices
    @ObservedObject private var store: MarketsService

    @State var searchText: String = ""
    @State var showIndicator: Bool = false
    @State private var noMore: Bool = false
    @State private var limitCells: Int = 25

    init(service: AuthenticatedServices) {
        self.service = service
        self.store = service.market

        service.market.tokenCategories.removeAll()
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

                    ListSection(title: !searchText.isEmpty ? "searched categories" : "\(store.categoriesFilters == .marketCapAsc ? "smallest market cap" : store.categoriesFilters == .marketCapDesc ? "top market cap" : store.categoriesFilters == .gainers ? "top 24hr gainers" : store.categoriesFilters == .losers ? "top 24hr losers" : store.categoriesFilters == .name ? "names A-Z" : "")", hasPadding: false, style: service.themeStyle) {
                        ForEach(store.tokenCategories.prefix(limitCells).indices, id: \.self) { index in
                            CategoryCell(service: service,
                                         data: store.tokenCategories[index],
                                         index: index,
                                         isLast: false,
                                         style: service.themeStyle, action: {
                                print("the id category going to: \(String(describing: store.tokenCategories[index]))")
                                marketRouter.route(to: \.categoryDetailView, store.tokenCategories[index])
                            })
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, searchText.isEmpty ? 0 : 20)

                    RefreshFooter(refreshing: $showIndicator, action: {
                        limitCells += 25
                        fetchTokenCategories()
                    }, label: {
                        if noMore {
                            FooterInformation().padding(.vertical)
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
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .automatic), prompt: "Search categories...")
        .onChange(of: searchText, perform: { text in
            store.searchCategoriesText = text
        })
        .onAppear {
            DispatchQueue.main.async {
                Tool.hiddenTabBar()
            }

            guard service.market.tokenCategories.isEmpty else { return }

            self.fetchTokenCategories()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Section {
                        Button {
                            store.tokenCategories.removeAll()
                            withAnimation(.easeInOut) { store.categoriesFilters = .name }
                            self.limitCells = 25
                            self.fetchTokenCategories()
                        } label: {
                            Label("Name", systemImage: store.categoriesFilters == .name ? "checkmark" : "")
                        }

                        Button {
                            store.tokenCategories.removeAll()
                            withAnimation(.easeInOut) { store.categoriesFilters = .marketCapDesc }
                            self.limitCells = 25
                            self.fetchTokenCategories()
                        } label: {
                            Label("Market Cap", systemImage: store.categoriesFilters == .marketCapDesc ? "checkmark" : "")
                        }

                        Button {
                            store.tokenCategories.removeAll()
                            withAnimation(.easeInOut) { store.categoriesFilters = .gainers }
                            self.limitCells = 25
                            self.fetchTokenCategories()
                        } label: {
                            Label("24hr Gainers", systemImage: store.categoriesFilters == .gainers ? "checkmark" : "")
                        }

                        Button {
                            store.tokenCategories.removeAll()
                            withAnimation(.easeInOut) { store.categoriesFilters = .losers }
                            self.limitCells = 25
                            self.fetchTokenCategories()
                        } label: {
                            Label("24hr Losers", systemImage: store.categoriesFilters == .losers ? "checkmark" : "")
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
        store.fetchTokenCategories(filter: store.categoriesFilters, limit: limitCells, skip: limitCells - 25, completion: {
            print("done fetching categories: \(store.tokenCategories.count) ** \(limitCells)")

            withAnimation(.easeInOut) {
                showIndicator = false
                noMore = store.tokenCategories.count < limitCells
            }
        })
    }

}
