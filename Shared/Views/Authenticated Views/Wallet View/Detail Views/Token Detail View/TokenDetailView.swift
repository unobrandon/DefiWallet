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
    @State var chartType: String

    @State private var tokenChart = [ChartValue]()

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

                CustomLineChart(data: tokenModel?.priceGraph?.price ?? tokenDetails?.priceGraph?.price ?? tokenChart.map({ $0.amount }),
                                profit: tokenModel?.priceChangePercentage24H ?? tokenDetails?.priceChangePercentage24H ?? 0 >= 0,
                                perspective: $walletStore.chartType)
                    .frame(height: 145)
                    .padding()

                if !tokenChart.isEmpty || tokenModel?.priceGraph?.price != nil || tokenDetails?.priceGraph?.price != nil {
                    HStack(alignment: .center, spacing: 0) {
                        Spacer()

                        VStack(alignment: .trailing, spacing: 8) {
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

                            Text(walletStore.getChartDuration(chartType))
                                .fontTemplate(DefaultTemplate.caption)
                        }
                        .padding(.top, 10)
                        .padding(10)
                        .onChange(of: chartType) { newValue in
//                            let val = newValue == "1H" ? "h" : newValue == "1D" ? "d" : newValue == "1W" ? "w" : newValue == "1M" ? "m" : newValue == "1Y" ? "y" : ""
//                            walletStore.emitSingleChartRequest(newValue)
                            UserDefaults.standard.setValue(newValue, forKey: "chartDetailType")
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
                    service.market.fetchTokenChart(id: externalId, from: Date(timeIntervalSinceNow: -3600), toDate: Date(), completion: { chart in
                        if let chart = chart {
                            self.tokenChart = chart
                        }
                    })
                }

//                guard tokenModel == nil, tokenDetails == nil, tokenDescriptor == nil else { return }

                service.market.fetchTokenDetails(id: external, address: externalId, completion: { tokenDescriptor in
                    if tokenDescriptor != nil, self.tokenDescriptor == nil {
                        self.tokenDescriptor = tokenDescriptor
                    }
                })
            })
        }
    }

    private func loadLocalTokenData(_ externalId: String?, completion: @escaping () -> Void) {
        guard tokenModel == nil,
              (tokenDetails != nil || externalId != nil),
              let completeBalance = self.walletStore.accountBalance?.completeBalance else {
            completion()
            return
        }

        if let item = completeBalance.first(where: { $0.nativeBalance?.externalId == externalId }) {
            self.tokenModel = item.nativeBalance
            completion()
            return
        } else {
            for bal in completeBalance {
                if let token = bal.tokens?.first(where: { $0.externalId == externalId }) {
                    self.tokenModel = token
                    break
                }
            }

            completion()
            return
        }
    }

}
