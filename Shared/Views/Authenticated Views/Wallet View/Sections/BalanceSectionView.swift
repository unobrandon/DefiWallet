//
//  BalanceSectionView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 3/23/22.
//

import SwiftUI

struct BalanceSectionView: View {

    @EnvironmentObject private var walletRouter: WalletCoordinator.Router

    @ObservedObject private var service: AuthenticatedServices
    @ObservedObject private var store: WalletService

    init(service: AuthenticatedServices) {
        self.service = service
        self.store = service.wallet
    }

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            HStack(alignment: .center, spacing: 10) {
                VStack(alignment: .leading, spacing: 0) {
                    HStack(alignment: .center, spacing: 5) {
                        Text("Total Balance")
                            .fontTemplate(DefaultTemplate.body_secondary)

                        if let change = store.accountPortfolio?.relativeChange24h {
                            ProminentRoundedLabel(text: (change >= 0 ? "+" : "") +
                                                  "\("".forTrailingZero(temp: change.truncate(places: 2)))%",
                                                  color: change >= 0 ? .green : .red,
                                                  style: service.themeStyle)
                        }
                    }

                    HStack(alignment: .center, spacing: 0) {
                        Text("$").fontTemplate(DefaultTemplate.titleSemiBold)

                        MovingNumbersView(number: store.accountPortfolio?.totalValue ?? 0.00,
                                          numberOfDecimalPlaces: 2,
                                          fixedWidth: 260,
                                          animationDuration: 0.4,
                                          showComma: true) { str in
                            Text(str).fontTemplate(DefaultTemplate.titleSemiBold)
                        }
                    }.mask(AppGradients.movingNumbersMask)

                    // stride(from: 1, to: store.accountChart.count - 1, by: 4).map({ store.accountChart[$0].amount })
                    LineChart(data: store.accountChart.map({ $0.amount }),
                              frame: CGRect(x: 20, y: 0, width: MobileConstants.screenWidth - 40, height: 140),
                              visualType: ChartVisualType.filled(color: Color("AccentColor"), lineWidth: 2), offset: 0,
                              currentValueLineType: CurrentValueLineType.dash(color: .secondary, lineWidth: 0, dash: [8]))
                        .frame(height: 140)
                        .padding(.top)
                        .padding(.bottom, 10)

                    if !store.accountChart.isEmpty {
                        HStack(spacing: 5) {
                            BorderedSelectedButton(title: "1H", systemImage: nil, size: .mini, tint: store.chartType == "h" ? Color("AccentColor") : nil, action: {
                                store.emitSingleChartRequest("h")
                            })

                            BorderedSelectedButton(title: "1D", systemImage: nil, size: .mini, tint: store.chartType == "d" ? Color("AccentColor") : nil, action: {
                                store.emitSingleChartRequest("d")
                            })

                            BorderedSelectedButton(title: "1W", systemImage: nil, size: .mini, tint: store.chartType == "w" ? Color("AccentColor") : nil, action: {
                                store.emitSingleChartRequest("w")
                            })

                            BorderedSelectedButton(title: "1M", systemImage: nil, size: .mini, tint: store.chartType == "m" ? Color("AccentColor") : nil, action: {
                                store.emitSingleChartRequest("m")
                            })

                            BorderedSelectedButton(title: "1Y", systemImage: nil, size: .mini, tint: store.chartType == "y" ? Color("AccentColor") : nil, action: {
                                store.emitSingleChartRequest("y")
                            })
                        }
                        .padding(.bottom)
                    }
                }
                Spacer()
            }

        }
        .padding(.horizontal)
        .padding(.top)

        TransactButtonView(style: service.themeStyle,
                           enableDeposit: false,
                           enableSend: true,
                           enableReceive: true,
                           enableSwap: true,
                           actionDeposit: { print("deposit")
        }, actionSend: { print("send")
        }, actionReceive: { print("receive")
        }, actionSwap: { print("swap")
        }).padding(.top)
    }

}
