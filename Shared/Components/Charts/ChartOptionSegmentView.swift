//
//  ChartOptionSegmentView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 4/29/22.
//

import SwiftUI

struct ChartOptionSegmentView: View {

    @ObservedObject private var service: AuthenticatedServices
    @ObservedObject private var store: WalletService

    private let action: (String) -> Void

    init(service: AuthenticatedServices, action: @escaping (String) -> Void) {
        self.service = service
        self.store = service.wallet
        self.action = action
    }

    var body: some View {
        HStack(spacing: 5) {
            BorderedSelectedButton(title: "1H", systemImage: nil, size: .mini, tint: store.chartType == "h" ? store.accountPortfolio?.relativeChange24h ?? 0 >= 0 ? Color.green : Color.red : nil, action: {
                action("h")
            })

            BorderedSelectedButton(title: "1D", systemImage: nil, size: .mini, tint: store.chartType == "d" ? store.accountPortfolio?.relativeChange24h ?? 0 >= 0 ? Color.green : Color.red : nil, action: {
                action("d")
            })

            BorderedSelectedButton(title: "1W", systemImage: nil, size: .mini, tint: store.chartType == "w" ? store.accountPortfolio?.relativeChange24h ?? 0 >= 0 ? Color.green : Color.red : nil, action: {
                action("w")
            })

            BorderedSelectedButton(title: "1M", systemImage: nil, size: .mini, tint: store.chartType == "m" ? store.accountPortfolio?.relativeChange24h ?? 0 >= 0 ? Color.green : Color.red : nil, action: {
                action("m")
            })

            BorderedSelectedButton(title: "1Y", systemImage: nil, size: .mini, tint: store.chartType == "y" ? store.accountPortfolio?.relativeChange24h ?? 0 >= 0 ? Color.green : Color.red : nil, action: {
                action("y")
            })
        }
    }

}
