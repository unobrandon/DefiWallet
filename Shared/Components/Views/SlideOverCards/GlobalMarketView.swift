//
//  GlobalMarketView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 4/18/22.
//

import SwiftUI

struct GlobalMarketView: View {

    @ObservedObject private var service: AuthenticatedServices
    @ObservedObject private var store: MarketsService

    init(service: AuthenticatedServices) {
        self.service = service
        self.store = service.market
    }

    var body: some View {
        VStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 5) {
                HStack(alignment: .center, spacing: 10) {
                    Image(systemName: "globe.americas")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32, alignment: .center)
                        .foregroundColor(.primary)

                Text("Global")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                }

                if let percent = store.globalMarketData?.marketCapChangePercentage24HUsd,
                   let num = Int(store.globalMarketData?.totalMarketCap?[service.currentUser.currency] ?? 0.0) {
                    Text("The global crypto market cap is $\("".formatLargeNumber(num, size: .large)), a \("".forTrailingZero(temp: percent.truncate(places: 2)))% \(percent >= 0 ? "increase" : "decrease") over the last day.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                        .lineLimit(4)
                        .padding(.bottom)
                }
            }

            ListSection(title: "General", hasPadding: false, style: service.themeStyle) {
                ListInfoSmallView(title: "Total Markets",
                                  info: "\(store.globalMarketData?.markets ?? 0)",
                                  secondaryInfo: nil,
                                  style: service.themeStyle,
                                  isLast: false)

                ListInfoSmallView(title: "Active Cryptocurrencies",
                                  info: "\(store.globalMarketData?.activeCryptocurrencies ?? 0)",
                                  secondaryInfo: nil,
                                  style: service.themeStyle,
                                  isLast: false)

                ListInfoSmallView(title: "Upcoming ICOs",
                                  info: "\(store.globalMarketData?.upcomingIcos ?? 0)",
                                  secondaryInfo: nil,
                                  style: service.themeStyle,
                                  isLast: false)

                ListInfoSmallView(title: "Ongoing ICOs",
                                  info: "\(store.globalMarketData?.ongoingIcos ?? 0)",
                                  secondaryInfo: nil,
                                  style: service.themeStyle,
                                  isLast: false)

                ListInfoSmallView(title: "Ended ICOs",
                                  info: "\(store.globalMarketData?.endedIcos ?? 0)",
                                  secondaryInfo: nil,
                                  style: service.themeStyle,
                                  isLast: false)
            }
        }
    }

}
