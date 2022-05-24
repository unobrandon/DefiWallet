//
//  TokenDetailView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 4/11/22.
//

import SwiftUI

struct TokenDetailView: View {

    @EnvironmentObject private var walletRouter: WalletCoordinator.Router

    @ObservedObject private var service: AuthenticatedServices
    @ObservedObject private var walletStore: WalletService
    @State private var tokenDetail: TokenDetails?
    @State private var tokenDescriptor: TokenDescriptor?
    @State private var externalId: String?

    @State private var tokenChart = [ChartValue]()

    init(tokenDetail: TokenDetails?, tokenDescriptor: TokenDescriptor?, externalId: String?, service: AuthenticatedServices) {
        self.service = service
        self.externalId = externalId
        self.tokenDetail = tokenDetail
        self.tokenDescriptor = tokenDescriptor
        self.walletStore = service.wallet
    }

    var body: some View {
        BackgroundColorView(style: service.themeStyle, {
            ScrollView(.vertical, showsIndicators: false) {
                HStack(alignment: .center, spacing: 10) {
                    VStack(alignment: .leading, spacing: 0) {
                        RemoteImage(tokenDescriptor?.imageLarge, size: 44)
                            .clipShape(Circle())
                            .overlay(Circle().strokeBorder(DefaultTemplate.borderColor.opacity(1.0), lineWidth: 1.0))
                            .shadow(color: Color.black.opacity(service.themeStyle == .shadow ? 0.15 : 0.0), radius: 4, x: 0, y: 2)
                            .padding(.vertical, 5)

                        HStack(alignment: .center, spacing: 5) {
                            Text(tokenDescriptor?.name ?? tokenDetail?.name ?? "").fontTemplate(DefaultTemplate.sectionHeader)

                            Text(tokenDescriptor?.symbol?.uppercased() ?? tokenDetail?.symbol?.uppercased() ?? "").fontTemplate(DefaultTemplate.sectionHeader_secondary)
                        }

                        HStack(alignment: .center, spacing: 0) {
                            Text(Locale.current.currencySymbol ?? "").fontTemplate(DefaultTemplate.titleSemiBold)

                            MovingNumbersView(number: tokenDetail?.currentPrice ?? 0.00,
                                              numberOfDecimalPlaces: tokenDetail?.currentPrice?.decimalCount() ?? 2 < 2 ? 2 : tokenDetail?.currentPrice?.decimalCount() ?? 2,
                                              fixedWidth: 260,
                                              animationDuration: 0.4,
                                              showComma: true) { str in
                                Text(str).fontTemplate(DefaultTemplate.titleSemiBold)
                            }
                        }.mask(AppGradients.movingNumbersMask)

                        HStack(alignment: .center, spacing: 5) {
                            if let change = tokenDetail?.priceChangePercentage24H {
                                ProminentRoundedLabel(text: (change >= 0 ? "+" : "") +
                                                      "\("".forTrailingZero(temp: change.truncate(places: 2)))%",
                                                      color: change >= 0 ? .green : .red,
                                                      style: service.themeStyle)

                                Text("last 24 hours")
                                    .fontTemplate(DefaultTemplate.caption)
                            }
                        }
                    }
                    Spacer()
                }
                .padding(.horizontal)

                CustomLineChart(data: tokenDetail?.priceGraph?.price ?? tokenChart.map({ $0.amount }), profit: tokenDetail?.priceChangePercentage24H ?? 0 >= 0)
    //                    LineChart(data: store.accountChart.map({ $0.amount }),
    //                              frame: CGRect(x: 20, y: 0, width: MobileConstants.screenWidth - 40, height: 140),
    //                              visualType: ChartVisualType.filled(color: store.accountPortfolio?.relativeChange24h ?? 0 >= 0 ? Color.green : Color.red, lineWidth: 2), offset: 0,
    //                              currentValueLineType: CurrentValueLineType.dash(color: .secondary, lineWidth: 0, dash: [8]))
                    .frame(height: 145)
                    .padding(.vertical, 10)

                if !tokenChart.isEmpty {
                    HStack(alignment: .center, spacing: 0) {
                        Spacer()
                        ChartOptionSegmentView(service: service, action: { item in
                            walletStore.emitSingleChartRequest(item)
                        })
                        .padding(.vertical, 10)
                    }
                }
            }
        })
        .navigationBarTitle(tokenDescriptor?.name ?? tokenDetail?.name ?? "Details", displayMode: .inline)
        .onDisappear() {
            self.tokenDescriptor = nil
            self.tokenDetail = nil
            self.externalId = nil
        }
        .onAppear {
            DispatchQueue.main.async {
                Tool.hiddenTabBar()
            }

            print("the token details are: \(String(describing: tokenDetail?.id ?? externalId))")
            service.market.fetchTokenDetails(id: tokenDetail?.id ?? externalId, address: externalId, completion: { tokenDescriptor in
                // Do your logic to get the token market data
                self.tokenDescriptor = tokenDescriptor

                var address: String? {
                    if let eth = tokenDescriptor?.ethAddress { return eth
                    } else if let avax = tokenDescriptor?.avaxAddress { return avax
                    } else if let fantom = tokenDescriptor?.fantomAddress { return fantom
                    } else if let solana = tokenDescriptor?.solanaAddress { return solana
                    } else if let river = tokenDescriptor?.moonriverAddress { return river
                    } else if let beam = tokenDescriptor?.moonbeamAddress { return beam
                    } else if let xdai = tokenDescriptor?.xdaiAddress { return xdai
                    } else { return nil }
                }

                print("successfully got the token details here: \n\(String(describing: externalId)) \nor: \n\(String(describing: address)) \nanswer: \n\(tokenDescriptor.debugDescription)")

                if let address = address {
                    service.market.emitFullInfoAssetSocket(address, currency: service.currentUser.currency)
                } else if let externalId = tokenDescriptor?.externalID {
                    service.market.fetchTokenChart(id: externalId, from: Date(timeIntervalSinceNow: -3600), toDate: Date(), completion: { chart in
                        if let chart = chart {
                            self.tokenChart = chart
                        }
                    })
                }
            })

        }
    }

}
