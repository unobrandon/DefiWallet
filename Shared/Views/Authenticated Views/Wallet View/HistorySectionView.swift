//
//  HistorySectionView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 3/21/22.
//

import SwiftUI

struct HistorySectionView: View {

    @ObservedObject private var service: AuthenticatedServices
    @ObservedObject private var store: WalletService

    @State var limitCells: Int = 5

    init(service: AuthenticatedServices) {
        self.service = service
        self.store = service.wallet

    }

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            if !store.history.isEmpty {
                SectionHeaderView(title: "History", actionTitle: store.history.count < limitCells ? "" : "See more", action: {
                    withAnimation(.easeOut) {
                        self.limitCells += 5
                    }
                })
                .padding(.vertical, 15)
            }

            ListSection(style: service.themeStyle) {
                ForEach(store.history.prefix(limitCells), id: \.self) { item in
                    HistoryListCell(service: service, data: item, isLast: store.history.count < limitCells ? store.history.last == item ? true : false : false, style: service.themeStyle, action: {
                        print("tapped history")
                    })

                    if store.history.last == item || item == store.history[limitCells - 1] {
                        ListStandardButton(title: "\(store.history.count - limitCells) more transactions", systemImage: "ellipsis.circle", isLast: true, style: service.themeStyle, action: {
                            print("tapped see more history")
                        })
                    }
                }
            }
        }
    }

}
