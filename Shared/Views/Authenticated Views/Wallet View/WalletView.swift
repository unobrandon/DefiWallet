//
//  WalletView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/13/22.
//

import SwiftUI
import Stinsen

struct WalletView: View {

    private let services: AuthenticatedServices

    @ObservedObject private var store: WalletService

    init(services: AuthenticatedServices) {
        self.services = services
        self.store = services.wallet

        self.fetchHistory()
    }

    var body: some View {
        ZStack {
            Color("baseBackground").ignoresSafeArea()

            ScrollView {
                Text("Networks")
                    .fontTemplate(DefaultTemplate.headingSemiBold)
                    .padding(.top)

                ForEach(store.completeBalance, id: \.self) { item in
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
                    .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.secondary.opacity(0.2)))
                    .padding(.horizontal)
                }

                Text("History")
                    .fontTemplate(DefaultTemplate.headingSemiBold)
                    .padding(.top)

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
        }
        .navigationTitle("Wallet")
    }

    private func fetchHistory() {
        store.fetchHistory(services.currentUser.address, completion: {
            print("done getting history")
        })

        store.fetchCustomGas(completion: {
            print("done getting gas")
        })

        store.fetchAccountBalance(services.currentUser.address, completion: {
            print("completed getting chain overview: \(store.accountBalance.count)")
        })
    }

}
