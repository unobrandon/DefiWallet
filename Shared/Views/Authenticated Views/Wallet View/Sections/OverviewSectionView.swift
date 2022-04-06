//
//  NetworkTotalSection.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 4/5/22.
//

import SwiftUI
import SwiftUICharts

struct OverviewSectionView: View {

    @EnvironmentObject private var walletRouter: WalletCoordinator.Router

    @ObservedObject private var service: AuthenticatedServices
    @ObservedObject private var store: WalletService
    private let completeBalance: CompleteBalance
    @State private var networkTotal: String

    private var rings: [RingProgressModel]

    init(completeBalance: CompleteBalance, service: AuthenticatedServices) {
        self.service = service
        self.store = service.wallet
        self.completeBalance = completeBalance
        self.networkTotal = service.wallet.getNetworkTotal(completeBalance)

        let totalAssets: Double = Double((completeBalance.tokenBalance?.count ?? 0) + (completeBalance.nfts?.result?.count ?? 0))
        let tokenProgress: Double = Double((completeBalance.tokenBalance?.count ?? 0)) / totalAssets
        let collectProgress: Double = Double((completeBalance.nfts?.result?.count ?? 0)) / totalAssets

        self.rings = [
            RingProgressModel(progress: collectProgress, value: "\(completeBalance.nfts?.result?.count ?? 0) NFTs", keyIcon: "infinity", keyColor: Color.purple),
            RingProgressModel(progress: tokenProgress, value: "\(completeBalance.tokenBalance?.count ?? 0) tokens", keyIcon: "bitcoinsign.circle", keyColor: service.wallet.getNetworkColor(completeBalance.network ?? ""))
        ]
    }

    var body: some View {
        HStack(alignment: .center, spacing: 5) {
            VStack(alignment: .leading, spacing: 5) {
                balanceSection
                mainnetSection
            }.frame(height: 210)

            breakdownSection
        }
        .padding(.top)
        .padding(.horizontal)
    }

    // MARK: - Balance Section
    @ViewBuilder
    private var balanceSection: some View {
        ListSection(hasPadding: false, style: service.themeStyle) {
            Button(action: {
                print("maybe spin the numbers here")
            }, label: {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Network Balance:")
                        .fontTemplate(DefaultTemplate.body_secondary)

                    HStack(alignment: .center, spacing: 5) {
                        Text("$").fontTemplate(DefaultTemplate.titleSemiBold)

                        if let num = Double(networkTotal) {
                            MovingNumbersView(number: num,
                                              numberOfDecimalPlaces: 2,
                                              fixedWidth: nil,
                                              showComma: true) { str in
                                Text(str).fontTemplate(DefaultTemplate.titleSemiBold)
                            }
                        }

                        Spacer()
                    }.mask(AppGradients.movingNumbersMask)
                }.padding()
            }).buttonStyle(DefaultInteractiveStyle(style: service.themeStyle))
        }
    }

    // MARK: - Mainnet Section
    @ViewBuilder
    private var  mainnetSection: some View {
        ListSection(hasPadding: false, style: service.themeStyle) {
            Button(action: {
                print("route to coin details view")
            }, label: {
                VStack(alignment: .leading, spacing: 10) {
                    HStack(alignment: .center, spacing: 10) {
                        Text("Mainnet").fontTemplate(DefaultTemplate.body_secondary)

                        Spacer()
                        HStack(alignment: .center, spacing: 2.5) {
                            if let num = Double(networkTotal) {
                                Text("$").fontTemplate(DefaultTemplate.gasPriceFont)

                                MovingNumbersView(number: num,
                                                  numberOfDecimalPlaces: 2,
                                                  fixedWidth: nil,
                                                  showComma: true) { str in
                                    Text(str).fontTemplate(DefaultTemplate.gasPriceFont)
                                }
                            }
                        }.mask(AppGradients.movingNumbersMask)

                        Image(systemName: "chevron.right")
                            .resizable()
                            .font(Font.title.weight(.semibold))
                            .scaledToFit()
                            .frame(width: 6, height: 12, alignment: .center)
                            .foregroundColor(.secondary)
                    }

                    LightChartView(data: [2, 17, 9, 23, 10, 8],
                                   type: .curved,
                                   visualType: .filled(color: store.getNetworkColor(completeBalance.network ?? ""), lineWidth: 3),
                                   offset: 0.2,
                                   currentValueLineType: .none)
                        .frame(height: 36, alignment: .center)
                }.padding()
            }).buttonStyle(DefaultInteractiveStyle(style: service.themeStyle))
        }
    }

    // MARK: - Breakdown Section
    @ViewBuilder
    private var  breakdownSection: some View {
        ListSection(hasPadding: false, style: service.themeStyle) {
            Button(action: {
                print("percentage here")
            }, label: {
                VStack(alignment: .center, spacing: 20) {
                    ZStack {
                        ForEach(rings.indices, id: \.self) { index in
                            AnimatedRingView(ring: rings[index], index: index, lineWidth: 7)
                        }
                    }.frame(width: 80, height: 80)

                    VStack(alignment: .center, spacing: 4) {
                        ForEach(rings) { ring in
                            Label {
                                Text(ring.value)
                                    .fontTemplate(DefaultTemplate.caption)
                                    .lineLimit(1)
                            } icon: {
                                Circle().frame(width: 8, height: 8).foregroundColor(ring.keyColor)
                            }
                        }
                    }
                }.padding()
                .frame(height: 210)
            })
            .buttonStyle(DefaultInteractiveStyle(style: service.themeStyle))
        }
    }

}
