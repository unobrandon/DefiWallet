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

    @State private var gridItems: [SwiftUI.GridItem] = {
        if MobileConstants.deviceType == .phone {
            return [SwiftUI.GridItem(.flexible()),
                    SwiftUI.GridItem(.flexible()),
                    SwiftUI.GridItem(.flexible())]
        } else {
            return [SwiftUI.GridItem(.flexible()),
                    SwiftUI.GridItem(.flexible()),
                    SwiftUI.GridItem(.flexible()),
                    SwiftUI.GridItem(.flexible()),
                    SwiftUI.GridItem(.flexible())]
        }
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

                detailsOverviewSection()
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

    // MARK: Token Details Header

    @ViewBuilder
    func detailsHeaderSection() -> some View {
        VStack(alignment: .center, spacing: 10) {
            HStack(alignment: .center, spacing: 10) {
                RemoteImage(tokenDescriptor?.imageLarge, size: 54)
                    .clipShape(Circle())
                    .overlay(Circle().strokeBorder(DefaultTemplate.borderColor.opacity(1.0), lineWidth: 1.0))
                    .shadow(color: Color.black.opacity(service.themeStyle == .shadow ? 0.15 : 0.0), radius: 4, x: 0, y: 2)
                    .padding(.vertical, 5)

                VStack(alignment: .leading, spacing: 5) {
                    Text(tokenDescriptor?.name ?? tokenDetail?.name ?? "").fontTemplate(DefaultTemplate.sectionHeader)

                    Text(tokenDescriptor?.symbol?.uppercased() ?? tokenDetail?.symbol?.uppercased() ?? "").fontTemplate(DefaultTemplate.sectionHeader_secondary)
                }

                Spacer()
                VStack(alignment: .trailing, spacing: 5) {
                    if let change = tokenDetail?.priceChangePercentage24H {
                        ProminentRoundedLabel(text: (change >= 0 ? "+" : "") +
                                              "\("".forTrailingZero(temp: change.truncate(places: 2)))%",
                                              color: change >= 0 ? .green : .red,
                                              style: service.themeStyle)

                        if let change = tokenDetail?.priceChange24H,
                           let isPositive = change >= 0 {
                            Text("\(isPositive ? "+" : "-")\(Locale.current.currencySymbol ?? "")\(change)")
                                .fontTemplate(FontTemplate(font: Font.system(size: 14.0), weight: .semibold, foregroundColor: isPositive ? .green : .red, lineSpacing: 0))
                        }
                    }
                }
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
        }
        .padding(.horizontal)
    }

    // MARK: Token Details Header

    @ViewBuilder
    func detailsOverviewSection() -> some View {
        ListSection(title: "overview", hasPadding: true, style: service.themeStyle) {
            LazyVGrid(columns: gridItems, alignment: .center, spacing: 5) {
                if let marketRank = tokenDetail?.marketCapRank {
                    StackedStatisticLabel(title: "Market Rank", metric: "#\(marketRank)")
                }

                if let marketCap = tokenDetail?.marketCap,
                   let change = tokenDetail?.marketCapChangePercentage24H {
                    StackedStatisticLabel(title: "Market Cap", metric: "\(Locale.current.currencySymbol ?? "")\("".formatLargeNumber(marketCap, size: .regular))", number: nil, percent: "\(change >= 0 ? "+" : "")\(change.reduceScale(to: 3))%", percentColor: change >= 0 ? .green : .red, style: service.themeStyle)
                }

                if let totalVolume = tokenDetail?.totalVolume,
                    let marketCap = tokenDetail?.marketCap {
                    StackedStatisticLabel(title: "Volume / Market Cap", metric: "\(Double(totalVolume / Double(marketCap)).reduceScale(to: 4))")
                }

                if let totalSupply = tokenDetail?.totalSupply {
                    StackedStatisticLabel(title: "Total Supply", metric: "\(Int(totalSupply))")
                }

                if let circulatingSupply = tokenDetail?.circulatingSupply {
                    StackedStatisticLabel(title: "Circulating Supply", metric: "\(Int(circulatingSupply))")
                }

                if let maxSupply = tokenDetail?.maxSupply {
                    StackedStatisticLabel(title: "Max Supply", metric: "\(Int(maxSupply))")
                }

                if let ath = tokenDetail?.ath,
                   let change = tokenDetail?.athChangePercentage {
                    StackedStatisticLabel(title: "All Time High", number: ath, percent: "\(change >= 0 ? "+" : "")\(change.reduceScale(to: 2))%", percentColor: change >= 0 ? .green : .red, style: service.themeStyle)
                }

                if let atl = tokenDetail?.atl,
                   let change = tokenDetail?.atlChangePercentage {
                    StackedStatisticLabel(title: "All Time Low", number: atl, percent: "\(change >= 0 ? "+" : "")\("".formatLargeNumber(Int(change), size: .small))%", percentColor: change >= 0 ? .green : .red, style: service.themeStyle)
                }
            }
            .padding(10)
        }

    }
}
