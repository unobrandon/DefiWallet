//
//  TokenDetailView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 4/11/22.
//

import SwiftUI

struct TokenDetailView: View {

    @EnvironmentObject private var walletRouter: WalletCoordinator.Router

    @ObservedObject var service: AuthenticatedServices
    @ObservedObject private var walletStore: WalletService
    @State var tokenDetail: TokenDetails?
    @State var tokenDescriptor: TokenDescriptor?
    @State var externalId: String?

    @State private var tokenChart = [ChartValue]()

    @State var gridItems: [SwiftUI.GridItem] = {
        return [SwiftUI.GridItem(.flexible()),
                SwiftUI.GridItem(.flexible()),
                SwiftUI.GridItem(.flexible())]
    }()

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
                detailsHeaderSection()

                CustomLineChart(data: tokenDetail?.priceGraph?.price ?? tokenChart.map({ $0.amount }), profit: tokenDetail?.priceChangePercentage24H ?? 0 >= 0)
                    .frame(height: 145)
                    .padding(.vertical, 10)

                if !tokenChart.isEmpty || tokenDetail?.priceGraph?.price != nil {
                    HStack(alignment: .center, spacing: 0) {
                        Spacer()
                        ChartOptionSegmentView(service: service, action: { item in
                            walletStore.emitSingleChartRequest(item)
                        })
                        .padding(.vertical, 10)
                    }
                }

                HStack(alignment: .center, spacing: 20) {
                    RoundedButton("Send", style: .primary, systemImage: "paperplane.fill", removePadding: true, action: {
                        print("send token")
                    })

                    RoundedButton("Swap", style: .primary, systemImage: "arrow.left.arrow.right", removePadding: true, action: {
                        print("send token")
                    })
                }
                .padding()
                .padding(.vertical)

                detailsOverviewSection()
                detailsInfoSection()

                FooterInformation()
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
                } else if tokenDetail?.priceGraph?.price == nil,
                          let externalId = tokenDescriptor?.externalID {
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
