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

    @State private var data: [TransactionResult] = []
    @State private var noMore: Bool = false
    @State var showIndicator: Bool = false
    @State private var networkFilter: String?
    @State private var directionFilter: TransactionDirection?
    @State private var limitCells: Int = 25
    @State private var searchText = ""

    init(filtered: String? = "", service: AuthenticatedServices) {
        self.networkFilter = filtered
        self.service = service
        self.store = service.wallet
    }

    var body: some View {
        BackgroundColorView(style: service.themeStyle, {
            ScrollView {
                ListSection(style: service.themeStyle) {
                    ForEach(filterHistory().sorted(by: { $0.timestamp ?? "0" > $1.timestamp ?? "0" }).prefix(limitCells), id: \.self) { item in
                        TransactionListCell(service: service, data: item, isLast: false, style: service.themeStyle, action: {
                            walletRouter.route(to: \.historyDetail, item)
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
        .searchable(text: $searchText, prompt: "Search transactions")
        .onAppear {
            DispatchQueue.main.async {
                Tool.hiddenTabBar()
            }

            guard let completeBalance = self.store.accountBalance?.completeBalance else { return }

            for network in completeBalance {
                guard let transact = network.transactions,
                      let result = transact.result else { return }

                for item in result {
                    data.append(item)
                }
            }
        }
        .navigationBarTitle("Transactions", displayMode: .large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    if networkFilter != nil || directionFilter != nil {
                        Button("Clear Filter", action: {
                            networkFilter = nil
                            directionFilter = nil
                        })
                    }

                    Section {
                        Button { withAnimation(.easeInOut) { networkFilter = "eth" }} label: {
                            Label("Ethereum", systemImage: networkFilter == "eth" ? "checkmark.circle.fill" : "circle")
                        }
                        Button { withAnimation(.easeInOut) { networkFilter = "polygon" }} label: {
                            Label("Polygon", systemImage: networkFilter == "polygon" ? "checkmark.circle.fill" : "circle")
                        }
                        Button { withAnimation(.easeInOut) { networkFilter = "bsc" }} label: {
                            Label("Binance Smart Chain", systemImage: networkFilter == "bsc" ? "checkmark.circle.fill" : "circle")
                        }
                        Button { withAnimation(.easeInOut) { networkFilter = "avalanche" }} label: {
                            Label("Avalanche", systemImage: networkFilter == "avalanche" ? "checkmark.circle.fill" : "circle")
                        }
                    }

                    Section {
                        Button { withAnimation(.easeInOut) { directionFilter = .sent }} label: {
                            Label("Sent", systemImage: directionFilter == .sent ? "checkmark.circle.fill" : "circle")
                        }
                        Button { withAnimation(.easeInOut) { directionFilter = .received }} label: {
                            Label("Received", systemImage: directionFilter == .received ? "checkmark.circle.fill" : "circle")
                        }
                        Button { withAnimation(.easeInOut) { directionFilter = .swap }} label: {
                            Label("Swapped", systemImage: directionFilter == .swap ? "checkmark.circle.fill" : "circle")
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

    private func filterHistory() -> [TransactionResult] {
        guard searchText.isEmpty else {
            return data.filter {
                $0.toAddress?.contains(searchText) ?? false ||
                $0.fromAddress?.contains(searchText) ?? false ||
                $0.network?.contains(searchText) ?? false ||
                $0.blockHash?.contains(searchText) ?? false }
        }

        if let network = networkFilter, directionFilter == nil {
            return data.filter({ $0.network == network })
        } else if let direction = directionFilter, networkFilter == nil {
            return data.filter({ $0.direction == direction })
        } else if let network = networkFilter, let direction = directionFilter {
            return data.filter({ $0.network == network && $0.direction == direction })
        } else {
            return data
        }
    }

}
