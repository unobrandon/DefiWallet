//
//  TokenDetailView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 4/11/22.
//

import SwiftUI

struct TokenDetailView: View {

    @EnvironmentObject var walletRouter: WalletCoordinator.Router
    @EnvironmentObject var marketRouter: MarketsCoordinator.Router

    @ObservedObject var service: AuthenticatedServices
    @ObservedObject private var walletStore: WalletService
    @State var tokenModel: TokenModel?
    @State var tokenDetails: TokenDetails?
    @State var tokenDescriptor: TokenDescriptor?
    @State var externalId: String?
    @State var scrollOffset: CGFloat = CGFloat.zero
    @State var openLinkSheet: Bool = false

    @State private var tokenChart = [ChartValue]()

    @State var gridItems: [SwiftUI.GridItem] = {
        return [SwiftUI.GridItem(.flexible()),
                SwiftUI.GridItem(.flexible()),
                SwiftUI.GridItem(.flexible())]
    }()

    var categories: [TokenCategory]?
    let fromMarketView: Bool

    init(fromMarketView: Bool? = nil, tokenModel: TokenModel?, tokenDetails: TokenDetails?, tokenDescriptor: TokenDescriptor?, externalId: String?, service: AuthenticatedServices) {
        self.fromMarketView = fromMarketView ?? false
        self.service = service
        self.externalId = externalId
        self.tokenModel = tokenModel
        self.tokenDetails = tokenDetails
        self.tokenDescriptor = tokenDescriptor
        self.walletStore = service.wallet

        guard let categories = tokenModel?.categories?.filter({ $0 != "" }) ?? tokenDetails?.categories?.filter({ $0 != "" }) ?? tokenDescriptor?.categories?.filter({ $0 != "" }) else {
            return
        }

        var allCategories: [TokenCategory] = []

        for category in categories {
            guard let category = category else { continue }

            let id = category.replacingOccurrences(of: " ", with: "-").replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").lowercased()
            let result = TokenCategory(id: id, externalId: id, name: category, description: nil, marketCap: nil, marketCapChange24H: nil, top3_Coins: nil, volume24H: nil, updatedAt: nil)
            allCategories.append(result)
        }

        self.categories = allCategories
    }

    var body: some View {
        BackgroundColorView(style: service.themeStyle, {
            ScrollView(.vertical, showsIndicators: false) {
                detailsHeaderSection()
                    .background(GeometryReader {
                        Color.clear.preference(key: ViewOffsetKey.self,
                            value: -$0.frame(in: .named("tokenDetail-scroll")).origin.y)
                    })
                    .onPreferenceChange(ViewOffsetKey.self) {
                        self.scrollOffset = $0
                    }

                CustomLineChart(data: tokenModel?.priceGraph?.price ?? tokenDetails?.priceGraph?.price ?? tokenChart.map({ $0.amount }),
                                profit: tokenModel?.priceChangePercentage24H ?? tokenDetails?.priceChangePercentage24H ?? 0 >= 0,
                                perspective: $walletStore.chartType)
                    .frame(height: 145)
                    .padding()

                if !tokenChart.isEmpty || tokenModel?.priceGraph?.price != nil || tokenDetails?.priceGraph?.price != nil {
                    HStack(alignment: .center, spacing: 0) {
                        Spacer()
                        ChartOptionSegmentView(service: service, action: { item in
                            walletStore.emitSingleChartRequest(item)
                        })
                        .padding(.top, 10)
                        .padding(10)
                    }
                }

                HStack(alignment: .center, spacing: 20) {
                    TransactButton(title: "Send \(tokenDescriptor?.symbol?.uppercased() ?? tokenModel?.symbol?.uppercased() ?? tokenDetails?.symbol?.uppercased() ?? "")", systemImage: "paperplane.fill", size: 50, style: service.themeStyle, action: {
                        print("send token")
                    })

                    TransactButton(title: "Swap \(tokenDescriptor?.symbol?.uppercased() ?? tokenModel?.symbol?.uppercased() ?? tokenDetails?.symbol?.uppercased() ?? "")",
                                   systemImage: "arrow.left.arrow.right",
                                   size: 50,
                                   style: service.themeStyle,
                                   action: {
                        print("swap token")
                    })
                }
                .padding()
                .padding(.vertical)

                if tokenModel != nil {
                    detailsEquitySection()
                }

                detailsOverviewSection()
                detailsAboutSection()
                detailsLinksSection()

                Spacer()
                FooterInformation()
                    .padding(.top, 40)
            }.coordinateSpace(name: "tokenDetail-scroll")
        })
        // .navigationBarTitle("", displayMode: .inline) //tokenDescriptor?.name ?? tokenDetail?.name ?? "Details", displayMode: .inline)
        .navigationBarTitle {
            if self.scrollOffset > 48 {
                HStack(alignment: .center, spacing: 10) {
                    if let imageSmall = tokenDescriptor?.imageSmall ?? tokenModel?.image ?? tokenDetails?.image {
                        RemoteImage(imageSmall, size: 28)
                            .clipShape(Circle())
                    }

                    Text(tokenDescriptor?.name ?? tokenModel?.name ?? tokenDetails?.name ?? "Details")
                        .fontTemplate(DefaultTemplate.sectionHeader_bold)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            DispatchQueue.main.async {
                Tool.hiddenTabBar()
            }

            print("the token details are: \(String(describing: tokenModel?.id ?? tokenModel?.externalId ?? tokenDetails?.tokenDescriptor?.externalID ?? tokenDescriptor?.externalID ??  "no id")) && \(String(describing: externalId))")

            if let completeBalance = self.walletStore.accountBalance?.completeBalance {
                completeBalance.forEach({ bal in
                    bal.tokens?.forEach({ token in
                        if tokenModel?.allAddress?.ethereum == token.tokenAddress || tokenDetails?.allAddress?.ethereum == token.tokenAddress || tokenDescriptor?.ethAddress == token.tokenAddress {
                            print("HAVE THIS ETH TOKEN!!!")
                        }

                        if tokenModel?.allAddress?.binance == token.tokenAddress || tokenDetails?.allAddress?.binance == token.tokenAddress {
                            print("HAVE THIS BINANCE TOKEN!!!")
                        }

                        if tokenModel?.allAddress?.avalanche == token.tokenAddress || tokenDetails?.allAddress?.avalanche == token.tokenAddress {
                            print("HAVE THIS Avalanche TOKEN!!!")
                        }

                        if tokenModel?.allAddress?.polygon_pos == token.tokenAddress || tokenDetails?.allAddress?.polygon_pos == token.tokenAddress {
                            print("HAVE THIS polygon TOKEN!!!")
                        }

                        if tokenModel?.allAddress?.fantom == token.tokenAddress || tokenDetails?.allAddress?.fantom == token.tokenAddress {
                            print("HAVE THIS fantom TOKEN!!!")
                        }

                        if tokenModel?.allAddress?.solana == token.tokenAddress || tokenDetails?.allAddress?.solana == token.tokenAddress {
                            print("HAVE THIS solana TOKEN!!!")
                        }
                    })
                })
            }

            let external = tokenModel?.id ?? tokenModel?.externalId ?? tokenDetails?.id ?? tokenDescriptor?.externalID ?? externalId

            service.market.fetchTokenDetails(id: external, address: externalId, completion: { tokenDescriptor in
                // Do your logic to get the token market data
                if tokenDescriptor != nil {
                    self.tokenDescriptor = tokenDescriptor
                }

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
