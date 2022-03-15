//
//  WalletView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/13/22.
//

import SwiftUI
import Stinsen

struct WalletView: View {

    @ObservedObject private var service: AuthenticatedServices

    @ObservedObject private var store: WalletService

    init(service: AuthenticatedServices) {
        self.service = service
        self.store = service.wallet

        self.fetchHistory()
    }

    var body: some View {
        BackgroundColorView(style: service.themeStyle, {
            ScrollView {

                HStack(alignment: .center, spacing: 10) {
                    Text("$0.00")
                        .fontTemplate(DefaultTemplate.titleBold)

                    Spacer()
                }
                .padding()

                TransactButtonView(style: service.themeStyle,
                                   enableDeposit: true,
                                   enableSend: true,
                                   enableReceive: true,
                                   enableSwap: true,
                                   actionDeposit: {
                    print("deposit")
                }, actionSend: {
                    print("send")
                }, actionReceive: {
                    print("receive")
                }, actionSwap: {
                    print("swap")
                })

                SectionHeaderView(title: "Networks", action: {
                    print("see more")
                })

                
                ForEach(store.completeBalance, id: \.self) { item in
                    ListSection(style: service.themeStyle) {
                        HStack(alignment: .center) {
                            VStack(alignment: .leading, spacing: 2.5) {
                                Text(item.network ?? "unknown")
                                    .fontTemplate(DefaultTemplate.bodySemibold)

                                if let tokenCount = item.tokenBalance?.count, tokenCount != 0 {
                                    Text("+\(tokenCount) tokens")
                                        .fontTemplate(DefaultTemplate.caption)
                                }

                                if let nfts = item.nfts, let nftCount = nfts.result?.count, nftCount != 0 {
                                    Text("+\(nftCount) collectables")
                                        .fontTemplate(DefaultTemplate.caption)
                                }
                            }

                            Spacer()
                            if let native = item.nativeBalance,
                               let balance = Double(native),
                               let formatted = (balance / Constants.eighteenDecimal),
                               let roundedValue = formatted.truncate(places: 4),
                               let network = item.network?.formatNetwork() {
                                Text("".forTrailingZero(temp: roundedValue) + " " + network)
                                    .font(Font.custom("Poppins-SemiBold", size: 14))
                                    .foregroundColor(Color.primary)
                                    .textCase(.uppercase)
                            }
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal)
                        .background(.secondary.opacity(0.2))
                    }
                }

                if !store.history.isEmpty {
                    SectionHeaderView(title: "History", actionTitle: "See more", action: {
                        print("see more")
                    })
                    .padding(.top)
                }

                ForEach(store.history, id: \.self) { item in
                    HStack(alignment: .center) {
                        VStack(alignment: .leading, spacing: 2.5) {
                            Text(item.direction == .incoming ? "Received" : item.direction == .outgoing ? "Sent" : "Exchange")
                                .fontTemplate(DefaultTemplate.bodyBold)

                            Text("\(item.amount) \(item.symbol)")
                                .fontTemplate(DefaultTemplate.bodyMedium)
                        }

                        Spacer()
                        VStack(alignment: .trailing, spacing: 2.5) {
                            Text("\(item.timeStamp.getFullElapsedInterval())")
                                .fontTemplate(DefaultTemplate.caption)

                            if let fromAddress = item.fromEns == nil ? item.from : item.fromEns {
                                Text("from: " + "\("".formatAddress(fromAddress))")
                                    .fontTemplate(DefaultTemplate.caption)
                            }
                        }
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal)
                    .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.secondary.opacity(0.2)))
                    .padding(.horizontal)
                }
            }
        })
        .navigationBarTitle("", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                HStack(alignment: .center, spacing: 10) {
                    UserAvatar(size: 38, user: service.currentUser, style: service.themeStyle)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(service.currentUser.username ?? "Welcome back")
                            .fontTemplate(DefaultTemplate.bodySemibold)

                        Text(service.currentUser.shortAddress)
                            .fontTemplate(DefaultTemplate.bodyMono_secondary)
                    }
                }
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                HStack(alignment: .center, spacing: 10) {
                    Button {
                        print("add")
                    } label: {
                        Image(systemName: "person.badge.plus")
                    }
                    .foregroundColor(Color.primary)

                    Button {
                        print("search")
                    } label: {
                        Image(systemName: "magnifyingglass")
                    }
                    .foregroundColor(Color.primary)
                }
            }
        }
    }

    private func fetchHistory() {
        store.fetchHistory(service.currentUser.address, completion: {
            print("done getting history")
        })

        store.fetchCustomGas(completion: {
            print("done getting gas")
        })

        store.fetchAccountBalance(service.currentUser.address, completion: {
            print("completed getting chain overview: \(store.accountBalance.count)")
        })
    }

}
