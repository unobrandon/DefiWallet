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
                VStack(alignment: .leading, spacing: 5) {
                    Text("Welcome to \nthe wallet view")
                        .fontTemplate(DefaultTemplate.title)

                    Text(services.currentUser.username)
                        .fontTemplate(DefaultTemplate.heading)

                    Text("The Sub-Header is here")
                        .fontTemplate(DefaultTemplate.subheading)

                    Text("The body texts!!")
                        .fontTemplate(DefaultTemplate.body)

                    Text("caption time")
                        .fontTemplate(DefaultTemplate.caption)
                }

                Text("History")
                    .fontTemplate(DefaultTemplate.title)
                    .padding(.top)

                ForEach(store.history, id: \.self) { item in
                    HStack(alignment: .center) {
                        VStack(alignment: .leading, spacing: 5) {
                            Text(item.direction == .incoming ? "Received" : item.direction == .outgoing ? "Sent" : "Exchange")
                                .fontTemplate(DefaultTemplate.subheading)

                            Text("\(item.symbol) \(item.amount)")
                                .fontTemplate(DefaultTemplate.body)
                        }

                        Spacer()
                        VStack(alignment: .trailing, spacing: 5) {
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
        store.fetchHistory(services.currentUser.walletAddress, completion: {
            print("done getting history")
        })

        store.fetchCustomGas(completion: {
            print("done getting gas")
        })
    }

}
