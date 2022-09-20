//
//  TrendingSectionView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 4/2/22.
//

import SwiftUI

struct TrendingSectionView: View {

    @EnvironmentObject private var marketRouter: MarketsCoordinator.Router

    @ObservedObject private var service: AuthenticatedServices
    @ObservedObject private var store: MarketsService

    @State private var limitCells: Int = 6
    @Binding var isTrendingLoading: Bool

    init(isLoading: Binding<Bool>, service: AuthenticatedServices) {
        self._isTrendingLoading = isLoading
        self.service = service
        self.store = service.market
    }

    var body: some View {
        ListSection(style: service.themeStyle) {
            VStack(alignment: .center, spacing: 0) {
                Button(action: {
                    self.actionTap()
                }, label: {
                    ListTitleView(title: "🔥 Trending", actionText: "Show all", style: service.themeStyle)
                })
                .buttonStyle(DefaultInteractiveStyle(style: service.themeStyle))

                if store.trendingCoins.isEmpty, isTrendingLoading {
                    LoadingView(title: "")
                } else if store.trendingCoins.isEmpty, !isTrendingLoading {
                    HStack {
                        Spacer()
                        Text("error loading trending").fontTemplate(DefaultTemplate.caption)
                        Spacer()
                    }.padding(.vertical, 30)
                }

                LazyVGrid(columns: Array(repeating: SwiftUI.GridItem(.flexible(), spacing: 2), count: MobileConstants.deviceType == .phone ? 2 : 3), alignment: .leading, spacing: 10) {
                    ForEach(store.trendingCoins.prefix(limitCells).indices, id: \.self) { index in
                        if let item = store.trendingCoins[index].item {
                            TrendingTokenListCell(service: service, data: item, index: index, style: service.themeStyle, action: { item in
                                print("tapped trending: \(item.name ?? "")")
                            })
                        }
                    }
                }
                .padding(10)
                .padding(.horizontal, 10)
            }
            .frame(minWidth: 100, maxWidth: .infinity)
        }
    }

    private func actionTap() {
        guard !store.trendingCoins.isEmpty else { return }

        #if os(iOS)
            HapticFeedback.lightHapticFeedback()
        #endif

       marketRouter.route(to: \.trendingDetail)
    }

}
