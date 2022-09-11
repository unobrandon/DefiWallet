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
    private let network: String?
    private var rings: [RingProgressModel]
    @State var hasCopiedAddress: Bool = false

    init(completeBalance: CompleteBalance, network: String? = nil, service: AuthenticatedServices) {
        self.service = service
        self.store = service.wallet
        self.completeBalance = completeBalance
        self.network = network

        let totalAssets: Double = Double((completeBalance.tokens?.count ?? 0) + (completeBalance.nfts?.allNfts?.count ?? 0))
        let tokenProgress: Double = Double((completeBalance.tokens?.count ?? 0)) / totalAssets
        let collectProgress: Double = Double((completeBalance.nfts?.allNfts?.count ?? 0)) / totalAssets

        self.rings = [
            RingProgressModel(progress: collectProgress, value: "\(completeBalance.nfts?.allNfts?.count ?? 0) NFTs", keyIcon: "infinity", keyColor: Color.purple),
            RingProgressModel(progress: tokenProgress, value: "\(completeBalance.tokens?.count ?? 0) tokens", keyIcon: "bitcoinsign.circle", keyColor: service.wallet.getNetworkColor(completeBalance.network ?? ""))
        ]
    }

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            VStack(alignment: .center, spacing: 10) {
                // Title
                HStack(alignment: .center, spacing: 10) {
                    if let network = network {
                        Image((network == "bsc" ? "binance" : network) + "_logo")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 48, height: 48, alignment: .center)
                            .clipShape(Circle())
                            .shadow(color: Color.black.opacity(service.themeStyle == .shadow ? 0.15 : 0.0), radius: 5, x: 0, y: 4)
                            .padding(.bottom, 5)

                        VStack(alignment: .leading, spacing: 0) {
                            Text((network == "eth" ? "Ethereum" : network == "bsc" ? "Binanace" : network.capitalized) + " Network").fontTemplate(DefaultTemplate.subheadingSemiBold)

                            Button(action: {
                                UIPasteboard.general.string = service.currentUser.address
                                HapticFeedback.successHapticFeedback()
                                showNotiHUD(image: "doc.on.doc", color: Color("AccentColor"), title: "Copied wallet address", subtitle: nil)
                                withAnimation {
                                    hasCopiedAddress = true
                                }

                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                    withAnimation {
                                        hasCopiedAddress = false
                                    }
                                }
                            }, label: {
                                HStack(alignment: .center, spacing: 5) {
                                    Text(service.currentUser.username == service.currentUser.address ? service.currentUser.shortAddress : service.currentUser.username ?? service.currentUser.shortAddress)
                                        .fontTemplate(FontTemplate(font: Font.custom("LabMono-Regular", size: 12), weight: .regular, foregroundColor: .secondary, lineSpacing: 0))

                                    Image(systemName: hasCopiedAddress ? "checkmark" : "doc.on.doc")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: hasCopiedAddress ? 10 : 12.5, height: hasCopiedAddress ? 10 : 12.5, alignment: .center)
                                        .font(Font.title.weight(.semibold))
                                        .foregroundColor(.secondary)
                                }
                            }).buttonStyle(ClickInteractiveStyle(0.95))
                        }
                    }
                    Spacer()
                }

                // Balance
                VStack(alignment: .leading, spacing: 0) {
                    Text("Network Balance:")
                        .fontTemplate(DefaultTemplate.body_secondary)

                    HStack(alignment: .top, spacing: 5) {
                        Text(Locale.current.currencySymbol ?? "").fontTemplate(DefaultTemplate.titleSemiBold)

                        if let num = service.wallet.getNetworkTotal(completeBalance) {
                            MovingNumbersView(number: num,
                                              numberOfDecimalPlaces: 2,
                                              fixedWidth: nil,
                                              theme: DefaultTemplate.titleSemiBold,
                                              showComma: true) { str in
                                Text(str).fontTemplate(DefaultTemplate.titleSemiBold)
                            }
                        }
                        Spacer()
                    }.mask(AppGradients.movingNumbersMask)
                }
            }

            Spacer()
            // Breakdown
            VStack(alignment: .center, spacing: 15) {
                ZStack {
                    ForEach(rings.indices, id: \.self) { index in
                        AnimatedRingView(ring: rings[index], index: index, lineWidth: 5)
                    }
                }.frame(width: 50, height: 50)

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
            }
        }
        .padding(.horizontal)
    }

}
