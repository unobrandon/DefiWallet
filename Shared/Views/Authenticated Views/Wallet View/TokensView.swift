//
//  TokensView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 6/28/22.
//

import SwiftUI

struct TokensView: View {

    @EnvironmentObject private var walletRouter: WalletCoordinator.Router

    @ObservedObject private var service: AuthenticatedServices
    @ObservedObject private var store: WalletService

    @State private var data: [TokenModel] = []
    @State private var noMore: Bool = false
    @State var showIndicator: Bool = false
    @State private var networkFilter: String?
    @State private var networkSelector: Int = 0
    @State private var limitCells: Int = 25
    @State private var searchText = ""

    init(filtered: String? = nil, service: AuthenticatedServices) {
        self.networkFilter = filtered
        self.service = service
        self.store = service.wallet
    }

    var body: some View {
        BackgroundColorView(style: service.themeStyle, {
            ScrollView {
                ListSection(title: "by token value", style: service.themeStyle) {
                    ForEach(filterTokens().prefix(limitCells), id: \.self) { item in
                        TokenBalanceCell(service: service, data: item, isLast: false, style: service.themeStyle, action: {
                            walletRouter.route(to: \.tokenDetail, item)
                        })
                    }
                }.padding(.top)

                RefreshFooter(refreshing: $showIndicator, action: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        limitCells += 25
                        withAnimation(.easeInOut) {
                            showIndicator = false
                            noMore = filterTokens().count <= limitCells
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
        .searchable(text: $searchText, prompt: "Search tokens")
        .onAppear {
            DispatchQueue.main.async {
                Tool.hiddenTabBar()
            }

            guard self.data.isEmpty,
                  let completeBalance = self.store.accountBalance?.completeBalance else { return }

            DispatchQueue.global(qos: .userInitiated).async {
                for network in completeBalance {
                    if let native = network.nativeBalance {
                        self.data.append(native)
                    }

                    guard let transact = network.tokens else { continue }

                    for item in transact {
                        self.data.append(item)
                    }
                }
            }
        }
        .onDisappear {
            self.data.removeAll()
        }
        .navigationBarTitle("Tokens", displayMode: .large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    if networkFilter != nil {
                        Button("Clear Filter", action: {
                            networkFilter = nil
                            networkSelector = 0
                        })
                    }

                    Section {
                        Button { withAnimation(.easeInOut) { networkFilter = "eth" }} label: {
                            Label("Ethereum", systemImage: networkFilter == "eth" ? "checkmark" : "")
                        }
                        Button { withAnimation(.easeInOut) { networkFilter = "polygon" }} label: {
                            Label("Polygon", systemImage: networkFilter == "polygon" ? "checkmark" : "")
                        }
                        Button { withAnimation(.easeInOut) { networkFilter = "bsc" }} label: {
                            Label("Binance Smart Chain", systemImage: networkFilter == "bsc" ? "checkmark" : "")
                        }
                        Button { withAnimation(.easeInOut) { networkFilter = "avalanche" }} label: {
                            Label("Avalanche", systemImage: networkFilter == "avalanche" ? "checkmark" : "")
                        }
                    }
                } label: {
                    HStack {
                        Image(systemName: "list.bullet")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 18, height: 18, alignment: .center)
                        Text("Sort")
                    }
                }
                .buttonStyle(.borderless)
                .controlSize(.small)
                .buttonBorderShape(.roundedRectangle)
                .buttonStyle(ClickInteractiveStyle(0.99))
            }
        }
    }

    private func filterTokens() -> [TokenModel] {
        guard searchText.isEmpty else {
            return data
                    .filter {
                        $0.name?.contains(searchText) ?? false ||
                        $0.symbol?.contains(searchText) ?? false ||
                        $0.network?.contains(searchText) ?? false }
                    .sorted(by: { $0.totalBalance ?? 0 > $1.totalBalance ?? 0 })
        }

        if let network = networkFilter {
            return data
                    .filter({ $0.network == network })
                    .sorted(by: { $0.totalBalance ?? 0 > $1.totalBalance ?? 0 })
        } else {
            return data.sorted(by: { $0.totalBalance ?? 0 > $1.totalBalance ?? 0 })
        }
    }

}
