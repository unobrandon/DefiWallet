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
                    Text("Total Balance").fontTemplate(DefaultTemplate.body_secondary)

                    HStack(alignment: .center, spacing: 0) {
                        Text(Locale.current.currencySymbol ?? "").fontTemplate(DefaultTemplate.titleSemiBold)

                        MovingNumbersView(number: store.accountBalance?.portfolioTotal ?? 0.00,
                                          numberOfDecimalPlaces: 2,
                                          fixedWidth: nil,
                                          theme: DefaultTemplate.titleSemiBold,
                                          animationDuration: 0.4,
                                          showComma: true) { str in
                            Text(str).fontTemplate(DefaultTemplate.titleSemiBold)
                        }
                    }.mask(AppGradients.movingNumbersMask)

                    if let change = store.accountPortfolio?.relativeChange24h {
                        ProminentRoundedLabel(text: "\(Locale.current.currencySymbol ?? "")" + "\(store.accountPortfolio?.absoluteChange24h?.truncate(places: 2) ?? 0.00)" + (change >= 0 ? "  (+" : "  (") + "\("".forTrailingZero(temp: change.truncate(places: 2)))%)",
                                              color: change >= 0 ? .green : .red,
                                              fontSize: 13.0,
                                              style: service.themeStyle)
                    }
                }
                Spacer()
            }

            // stride(from: 1, to: store.accountChart.count - 1, by: 4).map({ store.accountChart[$0].amount })
            CustomLineChart(data: store.accountChart.map({ $0.amount }), profit: store.accountPortfolio?.relativeChange24h ?? 0 >= 0)
//                    LineChart(data: store.accountChart.map({ $0.amount }),
//                              frame: CGRect(x: 20, y: 0, width: MobileConstants.screenWidth - 40, height: 140),
//                              visualType: ChartVisualType.filled(color: store.accountPortfolio?.relativeChange24h ?? 0 >= 0 ? Color.green : Color.red, lineWidth: 2), offset: 0,
//                              currentValueLineType: CurrentValueLineType.dash(color: .secondary, lineWidth: 0, dash: [8]))
                .frame(height: 145)
                .padding(.vertical, 10)

            if !store.accountChart.isEmpty {
                HStack(alignment: .center, spacing: 10) {
                    Spacer()
                    Text(store.getChartDuration(store.chartType))
                        .fontTemplate(DefaultTemplate.caption)

                    ChartOptionSegmentView(service: service, action: { item in
                        store.emitSingleChartRequest(item)
                    })
                    .padding([.vertical, .top], 15)
                }
            }
        }
        .padding()

        TransactButtonView(style: service.themeStyle,
                           enableDeposit: false,
                           enableSend: true,
                           enableReceive: false,
                           enableSwap: true,
        actionDeposit: {
            print("deposit")
        }, actionSend: {
            walletRouter.route(to: \.sendTo)
        }, actionReceive: {
            print("receive")
        }, actionSwap: {
            print("swap")
        }).padding(.top)
        .padding(.horizontal, 10)
    }

}
