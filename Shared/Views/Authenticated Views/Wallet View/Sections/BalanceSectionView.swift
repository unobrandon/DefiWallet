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

    @State var chart: [Double] = []

    init(service: AuthenticatedServices) {
        self.service = service
        self.store = service.wallet
    }

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            HStack(alignment: .center, spacing: 10) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Total Balance:")
                        .fontTemplate(DefaultTemplate.body_secondary)

                    HStack(alignment: .center, spacing: 0) {
                        Text("$").fontTemplate(DefaultTemplate.titleBold)

                        MovingNumbersView(number: store.accountPortfolio?.totalValue ?? 0.00,
                                          numberOfDecimalPlaces: 2,
                                          fixedWidth: 260,
                                          showComma: true) { str in
                            Text(str).fontTemplate(DefaultTemplate.titleBold)
                        }
                    }.mask(AppGradients.movingNumbersMask)
                }
                Spacer()
            }

            LineChart(data: store.accountChart?.map({ $0.value }) ?? [0, 7, 10, 8, 2],
                      frame: CGRect(x: 20, y: 0, width: MobileConstants.screenWidth - 40, height: 160),
                      visualType: ChartVisualType.filled(color: Color("AccentColor"), lineWidth: 3), offset: 0,
                      currentValueLineType: CurrentValueLineType.dash(color: .secondary, lineWidth: 2, dash: [8]))
                .frame(height: 160)
                .padding(.vertical)
        }
        .padding(.horizontal)
        .padding(.top)
        .onAppear {
            chart.removeAll()

            if let items = store.accountChart {
                chart = items.map({ $0.1 })
            }
        }

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
