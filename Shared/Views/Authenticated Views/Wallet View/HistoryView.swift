//
//  HistoryView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 3/21/22.
//

import SwiftUI

struct HistoryView: View {

    @EnvironmentObject private var walletRouter: WalletCoordinator.Router

    @ObservedObject private var service: AuthenticatedServices
    @ObservedObject private var store: WalletService

    @State private var noMore: Bool = false
    @State var showIndicator: Bool = false
    @State private var networkFilter: Network?
    @State private var networkSelector: Int = 0
    @State private var directionFilter: Direction?
    @State private var directionSelector: Int = 0
    @State private var limitCells: Int = 25
    @State private var searchText = ""

    init(filtered: Network? = nil, service: AuthenticatedServices) {
        self.networkFilter = filtered
        self.service = service
        self.store = service.wallet
    }

    var body: some View {
        BackgroundColorView(style: service.themeStyle, {
            ScrollView {
                ListSection(style: service.themeStyle) {
                    ForEach(filterHistory().prefix(limitCells), id: \.self) { item in
                        HistoryListCell(service: service, data: item,
                                        isLast: store.history.count < limitCells ? store.history.last == item ? true : false : false,
                                        style: service.themeStyle, action: {
                            walletRouter.route(to: \.historyDetail, item)
                            #if os(iOS)
                                HapticFeedback.rigidHapticFeedback()
                            #endif
                        })
                    }
                }.padding(.top)

                RefreshFooter(refreshing: $showIndicator, action: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        limitCells += 25
                        withAnimation(.easeInOut) {
                            showIndicator = false
                            noMore = filterHistory().count <= limitCells
                        }
                    }
                }, label: {
                    if noMore {
                        FooterInformation()
                    } else {
                        LoadingView(title: "loading more...")
                    }
                })
                .noMore(noMore)
                .preload(offset: 50)
            }.enableRefresh()
        })
//        .searchable(text: $searchText, prompt: "Search transactions")
        .onAppear {
            DispatchQueue.main.async {
                Tool.hiddenTabBar()
            }
        }
        .navigationBarTitle("Transactions", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    if networkFilter != nil || directionFilter != nil {
                        Button("Clear Filter", action: {
                            networkFilter = nil
                            directionFilter = nil
                            networkSelector = 0
                            directionSelector = 0
                        })
                    }

                    Section {
                        Button { withAnimation(.easeInOut) { networkFilter = .ethereum }} label: {
                            Label("Ethereum", systemImage: networkFilter == .ethereum ? "checkmark" : "")
                        }
                        Button { withAnimation(.easeInOut) { networkFilter = .polygon }} label: {
                            Label("Polygon", systemImage: networkFilter == .polygon ? "checkmark" : "")
                        }
                        Button { withAnimation(.easeInOut) { networkFilter = .binanceSmartChain }} label: {
                            Label("Binance Smart Chain", systemImage: networkFilter == .binanceSmartChain ? "checkmark" : "")
                        }
                        Button { withAnimation(.easeInOut) { networkFilter = .avalanche }} label: {
                            Label("Avalanche", systemImage: networkFilter == .avalanche ? "checkmark" : "")
                        }
                    }

                    Section {
                        Button { withAnimation(.easeInOut) { directionFilter = .outgoing }} label: {
                            Label("Sent", systemImage: directionFilter == .outgoing ? "checkmark" : "")
                        }
                        Button { withAnimation(.easeInOut) { directionFilter = .incoming }} label: {
                            Label("Received", systemImage: directionFilter == .incoming ? "checkmark" : "")
                        }
                        Button { withAnimation(.easeInOut) { directionFilter = .exchange }} label: {
                            Label("Exchanged", systemImage: directionFilter == .exchange ? "checkmark" : "")
                        }
                    }
                } label: {
                    Image(systemName: "slider.horizontal.3")
                }.foregroundColor(Color.primary)
            }
        }
    }

    private func filterHistory() -> [HistoryData] {
        guard searchText.isEmpty else {
            return self.store.history.filter {
                $0.address.contains(searchText) ||
                $0.from.contains(searchText) ||
                $0.destination.contains(searchText) ||
                $0.symbol.contains(searchText) ||
                $0.network.rawValue.contains(searchText) ||
                $0.account.contains(searchText) ||
                $0.hash.contains(searchText) }
        }

        if let network = networkFilter, directionFilter == nil {
            return self.store.history.filter({ $0.network == network })
        } else if let direction = directionFilter, networkFilter == nil {
            return self.store.history.filter({ $0.direction == direction })
        } else if let network = networkFilter, let direction = directionFilter {
            return self.store.history.filter({ $0.network == network && $0.direction == direction })
        } else {
            return self.store.history
        }
    }

}
