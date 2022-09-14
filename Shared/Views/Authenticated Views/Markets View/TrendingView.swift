//
//  TrendingDetailsView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 4/3/22.
//

import SwiftUI

struct TrendingView: View {

    @EnvironmentObject private var marketRouter: MarketsCoordinator.Router

    @ObservedObject private var service: AuthenticatedServices
    @ObservedObject private var store: MarketsService

    init(service: AuthenticatedServices) {
        self.service = service
        self.store = service.market
    }

    var body: some View {
        BackgroundColorView(style: service.themeStyle, {
            ScrollView(showsIndicators: true) {
                ListSection(style: service.themeStyle) {
                    ForEach(store.trendingCoins, id: \.self) { item in
                        if let item = item.item {
                            TrendingTokenStandardCell(service: service, data: item, isLast: false, style: service.themeStyle, action: {
                                guard let id = item.id else {
                                    #if os(iOS)
                                        HapticFeedback.errorHapticFeedback()
                                    #endif

                                    return
                                }

                                marketRouter.route(to: \.tokenExternalDetail, id)

                                print("open \(item.name ?? "")")
                                #if os(iOS)
                                    HapticFeedback.rigidHapticFeedback()
                                #endif
                            })
                        }
                    }
                }
                .padding(.vertical)

                FooterInformation()
            }
        })
        .navigationBarTitle("🔥 Trending", displayMode: .inline)
        .onAppear {
            DispatchQueue.main.async {
                Tool.hiddenTabBar()
            }
        }
    }

}
