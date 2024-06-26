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

    private var network: String?
    private var tokens: [TokenModel] {
        var allTokens: [TokenModel] = []

        guard let completeBalance = self.store.accountBalance?.completeBalance else { return [] }

        for token in completeBalance {
            if let native = token.nativeBalance {
                allTokens.append(native)
            }

            guard let tokens = token.tokens else {
                continue
            }

            for item in tokens {
                allTokens.append(item)
            }
        }

        if self.network != nil {
            allTokens = allTokens.filter({ $0.network == self.network })
        }

        return allTokens.sorted(by: { $0.totalBalance ?? 0 > $1.totalBalance ?? 0 })
    }

    @State private var limitCells: Int = 5
    @State private var emptyTokens: Bool = false
    @Binding private var isLoading: Bool

    init(isLoading: Binding<Bool>, network: String? = nil, service: AuthenticatedServices) {
        self._isLoading = isLoading
        self.service = service
        self.store = service.wallet
        self.network = network
    }

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            SectionHeaderView(title: "Tokens", actionTitle: tokens.isEmpty ? "" : "Show all", action: showMoreLess)
            .padding(.bottom, 5)

            if tokens.isEmpty, isLoading {
                LoadingView(title: "")
            } else if tokens.isEmpty, !isLoading {
                HStack {
                    Spacer()
                    Text("empty tokens").fontTemplate(DefaultTemplate.caption)
                    Spacer()
                }.padding(.vertical)
            } else {
                ListSection(style: service.themeStyle) {
                    ForEach(tokens.prefix(limitCells), id: \.self) { item in
                        TokenBalanceCell(service: service, data: item, isLast: false, style: service.themeStyle, action: {
                            walletRouter.route(to: \.tokenDetail, item)
                        })

                        if limitCells <= tokens.count, item == tokens.prefix(limitCells).last {
                            ListStandardButton(title: "show all...", systemImage: "ellipsis.circle", isLast: true, style: service.themeStyle, action: {
                                walletRouter.route(to: \.tokens, network)
                            })
                        }
                    }
                }
            }
        }
    }

    private func showMoreLess() {
        walletRouter.route(to: \.tokens, network)

        #if os(iOS)
            HapticFeedback.rigidHapticFeedback()
        #endif
    }

}
