//
//  MarketsView.swift
//  DefiWallet (iOS)
//
//  Created by Brandon Shaw on 2/14/22.
//

import SwiftUI
import SwiftUIX
import Stinsen

struct MarketsView: View {

    @ObservedObject private var service: AuthenticatedServices

    @ObservedObject private var store: MarketsService

    @State var searchText: String = ""
    @State var searchHide: Bool = true

    @State var gridViews: [AnyView] = []

    @State var isMarketCapLoading: Bool = false
    @State var isCategoriesLoading: Bool = false
    @State var isTrendingLoading: Bool = false

    init(service: AuthenticatedServices) {
        self.service = service
        self.store = service.market

        self.fetchGlobalData()
        self.fetchGasTrends()
        self.fetchTokenCategories()
        self.fetchTrending()
    }

    var body: some View {
        BackgroundColorView(style: service.themeStyle, {
            ScrollView(.vertical, showsIndicators: false) {
                Grid(gridViews.indices, id:\.self) { index in
                    gridViews[index]
                }
            }
        })
        .navigationTitle("Markets")
        .gridStyle(StaggeredGridStyle(.vertical, tracks: MobileConstants.deviceType == .phone ? 1 : 2, spacing: 0))
        .navigationSearchBar { SearchBar("Search tokens and more...", text: $searchText) }
        .navigationSearchBarHiddenWhenScrolling(searchHide)
        .onAppear {
            self.gridViews = [
                AnyView(TopSectionView(service: service)),
                AnyView(TrendingSectionView(isLoading: $isTrendingLoading, service: service)),
                AnyView(TopCoinsSectionView(isLoading: $isMarketCapLoading, service: service))
            ]
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                if let data = store.globalMarketData {
                    GlobalDataNavSection(data: data, service: service, action: {
                        print("tapped global data")
                    }).offset(y: -2.5)
                }
            }

            ToolbarItem(placement: .navigationBarTrailing, content: {
                GasPriceNavSection(service: service, action: {
                    print("tapped gas prices")
                })
            })
        }
    }

    private func fetchGlobalData() {
        store.fetchGlobalMarketData(completion: {
            print("gas is done loading")
        })
    }

    private func fetchGasTrends() {
        store.fetchEthGasPriceTrends(completion: {
            print("gas is done loading")
        })
    }

    private func fetchTokenCategories() {
        isCategoriesLoading = true

        store.fetchTokenCategories(completion: {
            print("categories is done loading")
            isCategoriesLoading = true
        })
    }

    private func fetchTrending() {
        isTrendingLoading = true

        store.fetchTrending(completion: {
            isTrendingLoading = false
        })
    }

}
