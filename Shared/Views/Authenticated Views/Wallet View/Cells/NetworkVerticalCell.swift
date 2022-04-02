//
//  NetworkVerticalCell.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 3/24/22.
//

import SwiftUI

struct NetworkVerticalCell: View {

    @EnvironmentObject private var walletRouter: WalletCoordinator.Router

    @ObservedObject private var service: AuthenticatedServices
    @ObservedObject private var store: WalletService

    private let network: CompleteBalance
    private let action: () -> Void

    init(network: CompleteBalance, service: AuthenticatedServices, action: @escaping () -> Void) {
        self.service = service
        self.store = service.wallet
        self.network = network
        self.action = action
    }

    var body: some View {
        ListSection(hasPadding: false, style: service.themeStyle) {
            Button(action: {
                self.actionTap()
            }, label: {
                VStack(alignment: .leading, spacing: 10) {
                    HStack(alignment: .center) {
                        Image((network.network == "bsc" ? "binance" : network.network ?? "") + "_logo")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 42, height: 42, alignment: .center)
                            .clipShape(Circle())
                            .overlay(Circle().strokeBorder(DefaultTemplate.borderColor.opacity(service.themeStyle == .border ? 1.0 : 0.0), lineWidth: 1))
                            .shadow(color: Color.black.opacity(service.themeStyle == .shadow ? 0.15 : 0.0), radius: 8, x: 0, y: 6)

                        Spacer()
                        Image(systemName: "chevron.right")
                            .resizable()
                            .font(Font.title.weight(.semibold))
                            .scaledToFit()
                            .frame(width: 6, height: 12, alignment: .center)
                            .foregroundColor(.secondary)
                    }

                    Text(network.network == "eth" ? "Ethereum" : network.network == "bsc" ? "Binanace" : network.network?.capitalized ?? "").fontTemplate(DefaultTemplate.subheadingSemiBold)

                    if let native = network.nativeBalance,
                       let balance = Double(native),
                       let formatted = (balance / Constants.eighteenDecimal),
                       let roundedValue = formatted.truncate(places: 4),
                       let networkFormatted = network.network?.formatNetwork() {
                        HStack(alignment: .center, spacing: 2) {
                            Text("".forTrailingZero(temp: roundedValue)).fontTemplate(DefaultTemplate.gasPriceFont)

                            Text(networkFormatted.capitalized).fontTemplate(DefaultTemplate.body_standard)
                        }
                    }

                    Spacer()
                    LightChartView(data: [2, 17, 9, 23, 10, 8],
                                   type: .curved,
                                   visualType: .filled(color: store.getNetworkColor(network.network ?? ""), lineWidth: 3),
                                   offset: 0.2,
                                   currentValueLineType: .none)
                            .frame(height: 40, alignment: .center)

                    HStack(alignment: .bottom) {
                        VStack(alignment: .leading, spacing: 2) {
                            if let tokenCount = network.tokenBalance?.count, tokenCount != 0 {
                                Text("+\(tokenCount) tokens")
                                    .fontTemplate(DefaultTemplate.caption)
                            }

                            if let nfts = network.nfts, let nftCount = nfts.result?.count, nftCount != 0 {
                                if let tokenCount = network.tokenBalance?.count, tokenCount != 0 {
                                    Divider().padding(.vertical, 5)
                                }

                                Text("+\(nftCount) collectables")
                                    .fontTemplate(DefaultTemplate.caption)
                            }
                        }

                        Spacer()
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
            }).buttonStyle(DefaultInteractiveStyle(style: service.themeStyle))
        }
        .padding(.horizontal, 10)
    }

    private func actionTap() {
        #if os(iOS)
            HapticFeedback.lightHapticFeedback()
        #endif

        action()
    }

}
