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
    @ObservedObject var walletStore: WalletService
    @State var tokenModel: TokenModel?
    @State var tokenDetails: TokenDetails?
    @State var tokenDescriptor: TokenDescriptor?
    @State var externalId: String?
    @State var scrollOffset: CGFloat = CGFloat.zero
    @State var openLinkSheet: Bool = false
    @State var chartType: String

    @State var tokenChart = [ChartValue]()

    @State var gridItems: [SwiftUI.GridItem] = {
        return [SwiftUI.GridItem(.flexible()),
                SwiftUI.GridItem(.flexible()),
                SwiftUI.GridItem(.flexible())]
    }()

    var categories: [TokenCategory]?
    let fromMarketView: Bool

    init(fromMarketView: Bool? = nil, tokenModel: TokenModel? = nil, tokenDetails: TokenDetails? = nil, tokenDescriptor: TokenDescriptor? = nil, externalId: String? = nil, service: AuthenticatedServices) {
        self.fromMarketView = fromMarketView ?? false
        self.service = service
        self.externalId = externalId
        self.tokenModel = tokenModel
        self.tokenDetails = tokenDetails
        self.tokenDescriptor = tokenDescriptor
        self.walletStore = service.wallet
        self.chartType = UserDefaults.standard.string(forKey: "chartDetailType") ?? "d"

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

                CustomLineChart(data: tokenChart.map({ $0.amount }),
                                timeline: tokenChart.map({ $0.timestamp }), profit: tokenChart.first?.amount ?? 0 <= tokenChart.last?.amount ?? 0,
                                perspective: $chartType)
                    .frame(height: 145)
                    .padding()
                    .padding(.top)

                if !tokenChart.isEmpty {
                    HStack(alignment: .center, spacing: 0) {
                        Spacer()

                        VStack(alignment: .trailing, spacing: 8) {
                            Picker("", selection: $chartType) {
                                Text("1D")
                                    .tag("d")
                                Text("1W")
                                    .tag("w")
                                Text("1M")
                                    .tag("m")
                                Text("1Y")
                                    .tag("y")
                                Text("MAX")
                                    .tag("max")
                                    .padding(.horizontal, 2.5)
                            }
                            .pickerStyle(.segmented)
                            .frame(width: 200, height: 30)

                            Text(walletStore.getChartDuration(chartType))
                                .fontTemplate(DefaultTemplate.caption)
                        }
                        .padding(.top, 10)
                        .padding(10)
                        .onChange(of: chartType) { newValue in
                            fetchTokenChart(newValue)
                            UserDefaults.standard.setValue(newValue, forKey: "chartDetailType")
                            HapticFeedback.lightHapticFeedback()
                        }
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

            let external = tokenModel?.id ?? tokenModel?.externalId ?? tokenDetails?.id ?? tokenDescriptor?.externalID ?? externalId

            print("the token details are: \(String(describing: external ?? "no id"))")

            loadLocalTokenData(external, completion: {
                if let externalId = external {
                    service.socket.startTokenDetailPriceTimer(externalId: externalId,
                                                              currency: service.currentUser.currency)

                    fetchTokenChart(chartType)
                }

                service.market.fetchTokenDetails(id: external, address: externalId, completion: { tokenDescriptor in
                    if tokenDescriptor != nil, self.tokenDescriptor == nil {
                        self.tokenDescriptor = tokenDescriptor
                    }
                })
            })
        }.onDisappear {
            service.socket.stopTokenDetailPriceTimer()
            self.walletStore.tokenDetailPrice = nil
        }
    }

    private func fetchTokenChart(_ type: String) {
        guard let external = tokenModel?.id ?? tokenModel?.externalId ?? tokenDetails?.id ?? tokenDescriptor?.externalID ?? externalId else {
            return
        }

        service.market.fetchTokenChart(id: external, days: type.getDaysFromChartType(), currency: service.currentUser.currency, completion: { chart in
            if let chart = chart {
                self.tokenChart = chart
            }
        })
    }

    private func loadLocalTokenData(_ externalId: String?, completion: @escaping () -> Void) {
        // The point of this is to merge an empty TokenModel (model of portfolio) to the TokenDetails (model of outside 'Market' trends)
        guard tokenModel == nil, (tokenDetails != nil || externalId != nil),
              let completeBalance = self.walletStore.accountBalance?.completeBalance else {
            completion()
            return
        }

        if let item = completeBalance.first(where: { $0.nativeBalance?.externalId == externalId }) {
            self.tokenModel = item.nativeBalance
            completion()
        } else {
            for bal in completeBalance {
                if let token = bal.tokens?.first(where: { $0.externalId == externalId }) {
                    self.tokenModel = token
                    break
                }
            }

            completion()
        }
    }

}
