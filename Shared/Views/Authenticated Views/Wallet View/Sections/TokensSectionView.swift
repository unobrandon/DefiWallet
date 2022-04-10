//
//  TokensSectionView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 4/5/22.
//

import SwiftUI

struct TokensSectionView: View {

    @EnvironmentObject private var walletRouter: WalletCoordinator.Router

    @ObservedObject private var service: AuthenticatedServices
    @ObservedObject private var store: WalletService

    private let tokens: [TokenBalance]
    private let network: String

    @State private var limitCells: Int = 4
    @State private var isLoading: Bool = false
    @State private var emptyTokens: Bool = false

    init(data: CompleteBalance, service: AuthenticatedServices) {
        self.service = service
        self.store = service.wallet
        self.tokens = data.tokenBalance ?? []
        self.network = data.network ?? ""
    }

    var body: some View {
        LazyVStack(alignment: .center, spacing: 0) {
            SectionHeaderView(title: "Tokens", actionTitle: tokens.isEmpty ? "" : tokens.count < limitCells ? "" : limitCells == 10 ? "Show less" : "Show more", action: showMoreLess)
            .padding(.vertical, 5)
            .padding(.top)

            ListSection(style: service.themeStyle) {
                if tokens.isEmpty, isLoading {
                    LoadingView(title: "")
                } else if tokens.isEmpty, !isLoading {
                    HStack {
                        Spacer()
                        Text("empty tokens").fontTemplate(DefaultTemplate.caption)
                        Spacer()
                    }.padding(.vertical)
                }

                ForEach(tokens.prefix(limitCells), id: \.self) { item in
                    TokenBalanceCell(service: service, data: item, network: network, isLast: tokens.count < limitCells ? tokens.last == item ? true : false : false, style: service.themeStyle, action: {
//                        walletRouter.route(to: \.historyDetail, item)

                        #if os(iOS)
                            HapticFeedback.rigidHapticFeedback()
                        #endif
                    })

                    if tokens.last == item || item == tokens[limitCells - 1] {
                        ListStandardButton(title: "show \(tokens.count - limitCells) more...", systemImage: "ellipsis.circle", isLast: true, style: service.themeStyle, action: {
//                            walletRouter.route(to: \.history, filter)

                            #if os(iOS)
                                HapticFeedback.rigidHapticFeedback()
                            #endif
                        })
                    }
                }
            }
        }
    }

    private func showMoreLess() {
//        walletRouter.route(to: \.history, filter)
        print("show all tokens view")

        #if os(iOS)
            HapticFeedback.rigidHapticFeedback()
        #endif
    }

}
