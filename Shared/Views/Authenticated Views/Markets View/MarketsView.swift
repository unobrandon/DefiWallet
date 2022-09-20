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

    @State var isMarketCapLoading: Bool = true
    @State var isTrendingLoading: Bool = false
    @State var showGasSheet: Bool = false
    @State var showGlobalSheet: Bool = false

    init(service: AuthenticatedServices) {
        self.service = service
        self.store = service.market
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
//        .navigationSearchBar { SearchBar("Search tokens and more...", text: $searchText) }
//        .navigationSearchBarHiddenWhenScrolling(searchHide)
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .automatic), prompt: "Search markets")
        .onAppear {
            DispatchQueue.main.async {
                Tool.showTabBar()
            }

            self.gridViews = [
                AnyView(TopSectionView(service: service)),
                AnyView(TrendingSectionView(isLoading: $isTrendingLoading, service: service)),
                AnyView(TopCoinsSectionView(isLoading: $isMarketCapLoading, service: service))
            ]

            fetchLocalMarketCap()
            store.startGasTimer()
            service.socket.startMarketCapTimer(currency: service.currentUser.currency)
            fetchGlobalData()
            fetchTrending()
        }
        .onDisappear {
            store.stopGasTimer()
            service.socket.stopMarketCapTimer()
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
            print("global market data is done loading")
        })
    }

    private func fetchTrending() {
        isTrendingLoading = true

        store.fetchTrending(completion: {
            DispatchQueue.main.async {
                isTrendingLoading = false
            }
        })
    }

    private func fetchLocalMarketCap() {
        service.socket.emitMarketChartUpdate(currency: service.currentUser.currency, perPage: "10", page: "1")

        guard store.coinsByMarketCap.isEmpty else { return }

        if let storage = StorageService.shared.marketCapStorage {
            storage.async.object(forKey: "marketCapList") { result in
                switch result {
                case .value(let list):
                    DispatchQueue.main.async {
                        store.coinsByMarketCap = list
                    }
                case .error(let error):
                    print("error getting local market cap: \(error.localizedDescription)")
                }
            }
        }
    }

}
