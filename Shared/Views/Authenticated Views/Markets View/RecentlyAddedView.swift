//
//  RecentlyAddedView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 6/7/22.
//

import SwiftUI

struct RecentlyAddedView: View {

    @EnvironmentObject private var walletRouter: MarketsCoordinator.Router

    @ObservedObject private var service: AuthenticatedServices
    @ObservedObject private var store: MarketsService

    init(service: AuthenticatedServices) {
        self.service = service
        self.store = service.market

        store.recentlyAddedTokens.removeAll()
        self.fetchRecentlyAdded()
    }

    var body: some View {
        BackgroundColorView(style: service.themeStyle, {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    Text("A list of the newest tokens added to the \(Constants.projectName)'s token list.")
                        .fontTemplate(DefaultTemplate.bodySemibold)
                        .multilineTextAlignment(.leading)

                    Text("If you know of a missing token or would like to add a new one, please feel free reaching out.")
                        .fontTemplate(DefaultTemplate.caption)
                        .multilineTextAlignment(.leading)
                }
                .padding(.vertical, 10)
                .padding(.horizontal)

                ListSection(style: service.themeStyle) {
                    ForEach(store.recentlyAddedTokens, id: \.self) { item in
                        TokenListStandardCell(service: service, data: item,
                                              isLast: false,
                                              style: service.themeStyle, action: {
                            walletRouter.route(to: \.detailsTokenDetail, item)

                            print("the item is: \(item)")
                        })
                    }
                }.padding(.top)

                FooterInformation()
            }
        })
        .navigationBarTitle("Recently Added", displayMode: .large)
        .onAppear {
            DispatchQueue.main.async {
                Tool.hiddenTabBar()
            }
        }
    }

    private func fetchRecentlyAdded() {
        store.fetchRecentlyAdded(completion: {
            print("done fetching recently added tokens: \(store.recentlyAddedTokens.count) **")
        })
    }

}
