//
//  NetworkDetailView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 4/5/22.
//

import SwiftUI

struct NetworkDetailView: View {

    @EnvironmentObject private var walletRouter: WalletCoordinator.Router

    @ObservedObject private var service: AuthenticatedServices
    @ObservedObject private var store: WalletService
    private let balance: CompleteBalance
    private let network: String?

    @State private var showSheet = false
    @State var isLoading = false
    @State var scrollOffset: CGFloat = CGFloat.zero

    let gridItems: [SwiftUI.GridItem] = MobileConstants.deviceType == .phone ? [SwiftUI.GridItem(.flexible())] : [SwiftUI.GridItem(.flexible()), SwiftUI.GridItem(.flexible())]

    init(data: CompleteBalance, network: String? = nil, service: AuthenticatedServices) {
        self.balance = data
        self.network = network
        self.service = service
        self.store = service.wallet
    }

    var body: some View {
        BackgroundColorView(style: service.themeStyle, {
            ScrollView(.vertical, showsIndicators: false) {
                OverviewSectionView(completeBalance: balance, network: balance.network, service: service)
                    .padding(.bottom)
                    .background(GeometryReader {
                        Color.clear.preference(key: ViewOffsetKey.self,
                            value: -$0.frame(in: .named("networkDetail-scroll")).origin.y)
                    })
                    .onPreferenceChange(ViewOffsetKey.self) {
                        self.scrollOffset = $0
                    }

                if let native = balance.nativeBalance {
                    ListSection(title: "native token", style: service.themeStyle) {
                        TokenBalanceCell(service: service, data: native, isLast: true, style: service.themeStyle, action: {
                            walletRouter.route(to: \.tokenDetail, native)
                        })
                    }
                }

                LazyVGrid(columns: gridItems, alignment: .center, spacing: 0) {
                    TokensSectionView(network: balance.network, service: service)
                    CollectablesSectionView(isLoading: $isLoading, network: network, service: service)
                    HistorySectionView(isLoading: $isLoading, service: service, network: network)
                }
            }.coordinateSpace(name: "networkDetail-scroll")
        })
        .navigationBarTitle {
            HStack(alignment: .center, spacing: 10) {
                if let network = network, self.scrollOffset > 48 {
                    Image((network == "bsc" ? "binance" : network) + "_logo")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 28, height: 28, alignment: .center)
                        .clipShape(Circle())

                    Text((network == "eth" ? "Ethereum" : network == "bsc" ? "Binanace" : network.capitalized) + " Network").fontTemplate(DefaultTemplate.sectionHeader_bold)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            DispatchQueue.main.async {
                Tool.hiddenTabBar()
            }
        }
    }

    private var backButton : some View {
        BorderlessButton(title: "Back", systemImage: "chevron.left", size: .regular, action: {
            walletRouter.pop()
        })
    }

}
