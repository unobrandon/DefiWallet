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
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 5) {
                Text("Welcome to \nthe wallet view")
                    .fontTemplate(DefaultTemplates.title)

                Text(services.currentUser.username)
                    .fontTemplate(DefaultTemplates.heading)

                Text("The Sub-Header is here")
                    .fontTemplate(DefaultTemplates.subheading)

                Text("The body texts!!")
                    .fontTemplate(DefaultTemplates.body)

                Text("caption time")
                    .fontTemplate(DefaultTemplates.caption)
            }.frame(width: MobileConstants.screenWidth)

            Text("History")
                .fontTemplate(DefaultTemplates.title)

            ForEach(store.history, id: \.self) { item in
                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(item.direction == .incoming ? "Received" : item.direction == .outgoing ? "Sent" : "Exchange")
                            .fontTemplate(DefaultTemplates.subheading)

                        if let fromAddress = item.fromEns == nil ? item.from : item.fromEns {
                            Text("from: " + "\("".formatAddress(fromAddress))")
                                .fontTemplate(DefaultTemplates.caption)
                        }
                    }

                    Spacer()
                    VStack(alignment: .trailing, spacing: 5) {
                        Text("\(item.timeStamp.getFullElapsedInterval())")
                            .fontTemplate(DefaultTemplates.caption)

                        Text("\(item.symbol) \(item.amount)")
                            .fontTemplate(DefaultTemplates.body)
                    }
                }
                .padding(.vertical, 10)
                .padding(.horizontal)
                .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.secondary.opacity(0.2)))
                .padding(.horizontal)
            }
        }
        .navigationTitle("Wallet")
        .onAppear {
            store.fetchHistory(services.currentUser.walletAddress, completion: {
                print("done getting history")
            })
        }
    }

}
