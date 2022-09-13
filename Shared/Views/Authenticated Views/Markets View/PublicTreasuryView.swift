//
//  PublicTreasuryView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 6/7/22.
//

import SwiftUI

struct PublicTreasuryView: View {

    @EnvironmentObject private var walletRouter: MarketsCoordinator.Router

    @ObservedObject private var service: AuthenticatedServices
    @ObservedObject private var store: MarketsService
    @State private var currentCoin: PublicTreasuryCoins = .bitcoin

    init(service: AuthenticatedServices) {
        self.service = service
        self.store = service.market

        store.publicTreasury = nil
        fetchPublicTreasury(currentCoin)
    }

    var body: some View {
        BackgroundColorView(style: service.themeStyle, {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    Text("A curated list of public companies that are holding large amounts of Bitcoin or Ethereum.")
                        .fontTemplate(DefaultTemplate.bodySemibold)
                        .multilineTextAlignment(.leading)

                    if let treasury = store.publicTreasury {
                        Text("The \(currentCoin.rawValue.capitalized) public treasury has a total of \("".formatLargeDoubleNumber(treasury.totalHoldings ?? 0, size: .large, scale: 2)) \(currentCoin == .bitcoin ? "BTC" : "ETH") with a value of $\("".formatLargeDoubleNumber(treasury.totalValueUsd ?? 0.00, size: .large, scale: 2)) that makes up a market cap dominance of \(treasury.marketCapDominance?.truncate(places: 2) ?? 0.00)%.")
                            .fontTemplate(DefaultTemplate.caption)
                            .multilineTextAlignment(.leading)
                    }
                }
                .padding([.horizontal, .top])

                if let companies = store.publicTreasury?.companies {
                    ListSection(style: service.themeStyle) {
                        ForEach(companies, id: \.self) { item in
                            CompanyCell(service: service, data: item,
                                        coin: currentCoin == .bitcoin ? "BTC" : "ETH",
                                        isLast: false,
                                        style: service.themeStyle, action: {
                                print("the item is: \(item)")

                                #if os(iOS)
                                    HapticFeedback.rigidHapticFeedback()
                                #endif
                            })
                        }
                    }.padding(.top)
                }

                FooterInformation()
            }
        })
        .navigationBarTitle("Public Treasury", displayMode: .large)
        .onAppear {
            DispatchQueue.main.async {
                Tool.hiddenTabBar()
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                CoinTreasuryDropdownButton(style: service.themeStyle, action: { publicTreasury in
                    store.publicTreasury = nil
                    currentCoin = publicTreasury
                    fetchPublicTreasury(publicTreasury)

                    #if os(iOS)
                        HapticFeedback.rigidHapticFeedback()
                    #endif
                })
            }
        }
    }

    private func fetchPublicTreasury(_ coin: PublicTreasuryCoins) {
        store.fetchPublicTreasury(coin: coin, completion: {  })
    }

}
