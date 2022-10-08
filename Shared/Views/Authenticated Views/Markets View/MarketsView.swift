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

    @State private var searchText: String = ""
    @State private var isMarketCapLoading: Bool = true
    @State private var isTrendingLoading: Bool = false
    @State private var showGasSheet: Bool = false
    @State private var showGlobalSheet: Bool = false

    init(service: AuthenticatedServices) {
        self.service = service
        self.store = service.market
    }

    var body: some View {
        BackgroundColorView(style: service.themeStyle, {
            ScrollView(.vertical, showsIndicators: false) {
                if searchText.isEmpty {
                    LazyVGrid(columns: Array(repeating: SwiftUI.GridItem(.flexible(), spacing: 2), count: MobileConstants.deviceType == .phone ? 1 : 2), alignment: .leading, spacing: 10) {
                        TopSectionView(service: service)
                        TrendingSectionView(isLoading: $isTrendingLoading, service: service)
                        TopCoinsSectionView(isLoading: $isMarketCapLoading, service: service)
                    }
                }
            }
        })
        .navigationBarTitle("Markets", displayMode: .large)
        .gridStyle(StaggeredGridStyle(.vertical, tracks: MobileConstants.deviceType == .phone ? 1 : 2, spacing: 0))
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .automatic), prompt: "Search markets")
        .onChange(of: searchText, perform: { text in
            store.searchMarketsText = text
        })
        .onAppear {
            DispatchQueue.main.async {
                Tool.showTabBar()
            }

            store.tokenCategories = []
            store.exchanges = []
            store.exchangeDetails = nil
            store.coinsByGains = []
            store.coinsByLosers = []
            store.recentlyAddedTokens = []
            store.publicTreasury = nil
            store.tokenCategoryList = []

            fetchLocalMarketCap()
            store.startGasTimer()
            service.socket.startMarketCapTimer(currency: service.currentUser.currency)
            fetchGlobalData()
            fetchTrending()
        }
        .onDisappear {
            store.stopGasTimer()
            service.socket.stopMarketCapTimer()
            gridViews = []
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
