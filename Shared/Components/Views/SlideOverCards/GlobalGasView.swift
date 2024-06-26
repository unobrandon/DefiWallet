//
//  GlobalGasView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 4/17/22.
//

import SwiftUI

struct GlobalGasView: View {

    @ObservedObject private var service: AuthenticatedServices
    @ObservedObject private var store: MarketsService

    @State var currentTab: String = "Ethereum"

    init(service: AuthenticatedServices) {
        self.service = service
        self.store = service.market
    }

    var body: some View {
        VStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 5) {
                HStack(alignment: .center, spacing: 10) {
                    Image(systemName: "fuelpump.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30, alignment: .center)
                        .foregroundColor(.primary)

                    Text("Gas Price")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                }

                Text("The gas price is a general reference for the transaction fees on the desired network.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
                    .lineLimit(3)
                    .padding(.bottom, 10)
            }.padding(.bottom)

            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Spacer()
                    NetworkDropdownButton(style: service.themeStyle, action: { network in
                        print("selected new network! \(network)")
                        currentTab = network
                    })
                }
                .padding(.bottom, 5)

//                ListSection(title: nil, hasPadding: false, style: service.themeStyle) {
//                    ListInfoSmallView(title: "🚶 Standard",
//                                      info: "\(store.ethGasPriceTrends?.current?.standard?.baseFeePerGas ?? 0)",
//                                      secondaryInfo: "wei",
//                                      style: service.themeStyle,
//                                      isLast: false)
//
//                    ListInfoSmallView(title: "🔥 Fast",
//                                      info: "\(store.ethGasPriceTrends?.current?.fast?.baseFeePerGas ?? 0)",
//                                      secondaryInfo: "wei",
//                                      style: service.themeStyle,
//                                      isLast: false)
//
//                    ListInfoSmallView(title: "🚀 Instant",
//                                      info: "\(store.ethGasPriceTrends?.current?.instant?.baseFeePerGas ?? 0)",
//                                      secondaryInfo: "wei",
//                                      style: service.themeStyle,
//                                      isLast: true)
//                }

//                if let gas = store.ethGasPriceTrends,
//                   let trends = gas.trend {
//                    ZStack(alignment: .center) {
//                        VStack(alignment: .trailing, spacing: 10) {
//                            LightChartView(data: trends.prefix(store.gasChartLimit).map({ $0.baseFee ?? 0 }).reversed(),
//                                           type: .curved,
//                                           visualType: .filled(color: .purple, lineWidth: 2.5),
//                                           offset: 0.2,
//                                           currentValueLineType: .none)
//                                    .frame(height: 80, alignment: .center)
//                                    .blur(radius: CGFloat(currentTab != "Ethereum" ? 10 : 0))
//
//                            HStack(spacing: 5) {
//                                BorderedSelectedButton(title: "12H", systemImage: nil, size: .mini, tint: store.gasChartLimit == 12 ? Color("AccentColor") : nil, action: {
//                                    store.gasChartLimit = 12
//                                })
//
//                                BorderedSelectedButton(title: "24H", systemImage: nil, size: .mini, tint: store.gasChartLimit == 24 ? Color("AccentColor") : nil, action: {
//                                    store.gasChartLimit = 24
//                                })
//
//                                BorderedSelectedButton(title: "3D", systemImage: nil, size: .mini, tint: store.gasChartLimit == 72 ? Color("AccentColor") : nil, action: {
//                                    store.gasChartLimit = 72
//                                })
//
//                                BorderedSelectedButton(title: "7D", systemImage: nil, size: .mini, tint: store.gasChartLimit == trends.count - 1 ? Color("AccentColor") : nil, action: {
//                                    store.gasChartLimit = trends.count - 1
//                                })
//                            }
//                            .padding(.bottom)
//                            .blur(radius: CGFloat(currentTab != "Ethereum" ? 10 : 0))
//                        }
//
//                        Text("Gas trends are only on Ethereum. \nMore networks are coming soon.")
//                            .fontTemplate(DefaultTemplate.bodyMedium)
//                            .multilineTextAlignment(.center)
//                            .padding(.horizontal)
//                            .opacity(currentTab == "Ethereum" ? 0 : 1)
//                    }
//                    .padding(.top)
//                }
            }
        }
    }

}
