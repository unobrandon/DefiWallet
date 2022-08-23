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
    @State var chartType: String

    init(service: AuthenticatedServices) {
        self.service = service
        self.store = service.wallet
        self.chartType = UserDefaults.standard.string(forKey: "chartType") ?? "d"
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
                        ProminentRoundedLabel(text: "\(store.accountPortfolio?.absoluteChange24h?.convertToCurrency() ?? "")" + (change >= 0 ? "  (+" : "  (") + "\("".forTrailingZero(temp: change.truncate(places: 2)))%)",
                                              color: change >= 0 ? .green : .red,
                                              fontSize: 13.0,
                                              style: service.themeStyle)
                    }
                }
                Spacer()
            }

            // stride(from: 1, to: store.accountChart.count - 1, by: 4).map({ store.accountChart[$0].amount })
            CustomLineChart(data: store.accountChart.map({ $0.amount }), timeline: store.accountChart.map({ $0.timestamp }), profit: store.accountPortfolio?.relativeChange24h ?? 0 >= 0, perspective: $chartType)
//                    LineChart(data: store.accountChart.map({ $0.amount }),
//                              frame: CGRect(x: 20, y: 0, width: MobileConstants.screenWidth - 40, height: 140),
//                              visualType: ChartVisualType.filled(color: store.accountPortfolio?.relativeChange24h ?? 0 >= 0 ? Color.green : Color.red, lineWidth: 2), offset: 0,
//                              currentValueLineType: CurrentValueLineType.dash(color: .secondary, lineWidth: 0, dash: [8]))
                .frame(height: 160)
                .padding([.vertical, .top])
                .padding(.top)

            if !store.accountChart.isEmpty {
                HStack(alignment: .center, spacing: 0) {
                    Spacer()

                    VStack(alignment: .trailing, spacing: 8) {
                        HStack(alignment: .center, spacing: 4) {
                            Button {
                                print("show warrning about only supporting ETH network chart")
                            } label: {
                                Label("", systemImage: "info.circle")
                                    .foregroundColor(.secondary)
                                    .imageScale(.small)
                            }

                            Picker("", selection: $chartType) {
                                Text("1H")
                                    .tag("h")
                                Text("1D")
                                    .tag("d")
                                Text("1W")
                                    .tag("w")
                                Text("1M")
                                    .tag("m")
                                Text("1Y")
                                    .tag("y")
                            }
                            .pickerStyle(.segmented)
                            .frame(width: 200, height: 30)
                        }

                        Text(store.getChartDuration(store.chartType))
                            .fontTemplate(DefaultTemplate.caption)
                    }
                    .padding([.vertical, .top], 15)
                    .padding(.top, 15)
                    .onChange(of: chartType) { newValue in
//                        let val = newValue == "1H" ? "h" : newValue == "1D" ? "d" : newValue == "1W" ? "w" : newValue == "1M" ? "m" : newValue == "1Y" ? "y" : ""
                        store.emitSingleChartRequest(newValue)
                    }
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
            walletRouter.route(to: \.swapToken)
        })
        .padding([.horizontal, .top], 10)
    }

}
