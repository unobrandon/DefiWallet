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

    @EnvironmentObject private var marketRouter: MarketsCoordinator.Router

    @ObservedObject private var service: AuthenticatedServices
    @ObservedObject private var store: MarketsService

    @State var searchText: String = ""
    @State var searchHide: Bool = true

    @State var gridViews: [AnyView] = []

    @State var isMarketCapLoading: Bool = false
    @State var isCategoriesLoading: Bool = false
    @State var isTrendingLoading: Bool = false
    @State var showGasSheet: Bool = false
    @State var showGlobalSheet: Bool = false

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
        .navigationBarTitle("Markets", displayMode: .large)
        .gridStyle(StaggeredGridStyle(.vertical, tracks: MobileConstants.deviceType == .phone ? 1 : 2, spacing: 0))
        .navigationSearchBar { SearchBar("Search tokens and more...", text: $searchText) }
        .navigationSearchBarHiddenWhenScrolling(searchHide)
        .onAppear {
            print("markets view did appear")
            DispatchQueue.main.async {
                Tool.showTabBar()
            }

            self.gridViews = [
                AnyView(TopSectionView(service: service)),
                AnyView(TrendingSectionView(isLoading: $isTrendingLoading, service: service)),
                AnyView(TopCoinsSectionView(isLoading: $isMarketCapLoading, service: service))
            ]
        }
        .onDisappear {
            print("markets view did disappear")
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                if let data = store.globalMarketData {
                    GlobalDataNavSection(data: data, service: service, action: {
                        #if os(iOS)
                            HapticFeedback.rigidHapticFeedback()
                        #endif

                        SOCManager.present(isPresented: $showGlobalSheet) {
                            GlobalMarketView(service: service)
                        }
                    }).offset(y: -2.5)
                }
            }

            ToolbarItem(placement: .navigationBarTrailing, content: {
                GasPriceNavSection(service: service, action: {
                    #if os(iOS)
                        HapticFeedback.rigidHapticFeedback()
                    #endif

                    SOCManager.present(isPresented: $showGasSheet) {
                        GlobalGasView(service: service)
                    }
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
