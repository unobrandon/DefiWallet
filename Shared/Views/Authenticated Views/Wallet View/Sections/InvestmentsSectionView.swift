//
//  InvestmentsSectionView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 6/17/22.
//

import SwiftUI

struct InvestmentsSectionView: View {

    @EnvironmentObject private var walletRouter: WalletCoordinator.Router

    @ObservedObject private var service: AuthenticatedServices
    @ObservedObject private var store: WalletService

    @Binding private var isLoading: Bool
    @State private var limitCells: Int = 5
    var data: [Int] = [1,2,1,1,1,1,1,1,0]

    init(isLoading: Binding<Bool>, service: AuthenticatedServices) {
        self._isLoading = isLoading
        self.service = service
        self.store = service.wallet
    }

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            SectionHeaderView(title: "Investments", actionTitle: store.history.isEmpty ? "" : "Show all", action: showMoreLess)
            .padding(.vertical, 5)

            ListSection(style: service.themeStyle) {
                if store.history.isEmpty, isLoading {
                    LoadingView(title: "")
                } else if store.history.isEmpty, !isLoading {
                    HStack {
                        Spacer()
                        Text("no investments found").fontTemplate(DefaultTemplate.caption)
                        Spacer()
                    }.padding(.vertical, 30)
                }

//                ForEach(data.prefix(limitCells), id: \.self) { item in
//                    TransactionListCell(service: service, data: item, isLast: false, style: service.themeStyle, action: {
//                        #if os(iOS)
//                            HapticFeedback.rigidHapticFeedback()
//                        #endif
//                    })
//                }
            }
        }
    }

    private func showMoreLess() {
        #if os(iOS)
            HapticFeedback.rigidHapticFeedback()
        #endif
    }

}
