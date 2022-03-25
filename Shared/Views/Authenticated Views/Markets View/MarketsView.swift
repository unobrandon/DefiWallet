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

    @State var gridViews: [AnyView]

    init(service: AuthenticatedServices) {
        self.service = service
        self.store = service.market
        self.gridViews = [
            AnyView(TopCoinsSectionView(service: service))
        ]

        self.fetchTopCoins()
    }

    var body: some View {
        BackgroundColorView(style: service.themeStyle, {
            ScrollView {
                Grid(gridViews.indices, id:\.self) { index in
                    gridViews[index]
                }
            }
        })
        .navigationTitle("Markets")
        .gridStyle(StaggeredGridStyle(.vertical, tracks: MobileConstants.deviceType == .phone ? 1 : 2, spacing: 0))
        .navigationSearchBar { SearchBar("Search tokens and more...", text: $searchText) }
        .navigationSearchBarHiddenWhenScrolling(searchHide)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing, content: {
                Button(action: {
                    self.store.fetchEthGasPriceTrends(completion: {
                        print("gas reloaded")
                    })
                }, label: {
                    HStack(alignment: .center, spacing: 10) {
                        if let gas = store.ethGasPriceTrends,
                           let trends = gas.trend,
                           let standard = gas.current?.standard {
                            LightChartView(data: trends[0...6].map({ $0.baseFee ?? 0 }).reversed(),
                                           type: .curved,
                                           visualType: .filled(color: .purple, lineWidth: 3),
                                           offset: 0.2,
                                           currentValueLineType: .none)
                                    .frame(width: 50, height: 28, alignment: .center)

                            MovingNumbersView(number: Double(standard.baseFeePerGas ?? 0), numberOfDecimalPlaces: 0, fixedWidth: 22, showComma: false) { gas in
                                Text(gas)
                                    .fontTemplate(DefaultTemplate.gasPriceFont)
                            }
                            .mask(AppGradients.movingNumbersMask)

                            Image(systemName: "fuelpump.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 16, height: 18, alignment: .center)
                                .foregroundColor(.primary)
                        }
                    }
                })
            })
        }
    }

    private func fetchTopCoins() {
        store.fetchCoinsByMarketCap(currency: service.currentUser.currency, completion: {
            print("completed getting CoinsByMarketCap: \(service.currentUser.currency)")
            store.isMarketCapLoading = false
        })
    }

}
