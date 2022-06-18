//
//  NetworkCell.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 3/23/22.
//

import SwiftUI

struct NetworkCell: View {

    @EnvironmentObject private var walletRouter: WalletCoordinator.Router

    @ObservedObject private var service: AuthenticatedServices
    @ObservedObject private var store: WalletService

    private let network: CompleteBalance

    init(network: CompleteBalance, service: AuthenticatedServices) {
        self.service = service
        self.store = service.wallet
        self.network = network
    }

    var body: some View {
        ListSection(style: service.themeStyle) {
            HStack(alignment: .center, spacing: 10) {
                Image((network.network == "bsc" ? "binance": network.network ?? "") + "_logo")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 42, height: 42, alignment: .center)
                    .clipShape(Circle())

                VStack(alignment: .leading, spacing: 0) {
                    HStack(alignment: .center) {
                        Text(network.network?.capitalized ?? "").fontTemplate(DefaultTemplate.gasPriceFont)

                        Spacer()
                        LightChartView(data: [2, 17, 9, 23, 10, 8],
                                       type: .curved,
                                       visualType: .filled(color: store.getNetworkColor(network.network ?? ""), lineWidth: 3),
                                       offset: 0.2,
                                       currentValueLineType: .none)
                                .frame(width: 62, height: 25, alignment: .center)
                                .padding(.horizontal, 2.5)

                        Image(systemName: "chevron.right")
                            .resizable()
                            .font(Font.title.weight(.semibold))
                            .scaledToFit()
                            .frame(width: 6, height: 12, alignment: .center)
                            .foregroundColor(.secondary)
                    }

                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 2) {
                            if let tokenCount = network.tokenBalance?.count, tokenCount != 0 {
                                Text("+\(tokenCount) tokens")
                                    .fontTemplate(DefaultTemplate.caption)
                            }

                            if let nfts = network.nfts, let nftCount = nfts.allNfts?.count, nftCount != 0 {
                                Text("+\(nftCount) collectables")
                                    .fontTemplate(DefaultTemplate.caption)
                            }
                        }

                        Spacer()
                        if let native = network.nativeBalance,
                           let balance = Double(native),
                           let formatted = (balance / Constants.eighteenDecimal),
                           let roundedValue = formatted.truncate(places: 4),
                           let networkFormated = network.network?.formatNetwork() {
                            HStack(alignment: .center, spacing: 2) {
                                Text("".forTrailingZero(temp: roundedValue)).fontTemplate(DefaultTemplate.bodyBold)

                                Text(networkFormated).fontTemplate(DefaultTemplate.body_standard)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
        }
    }

}
