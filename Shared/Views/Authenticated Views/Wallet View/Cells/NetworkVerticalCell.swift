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

    init(network: CompleteBalance, service: AuthenticatedServices) {
        self.service = service
        self.store = service.wallet
        self.network = network
    }

    var body: some View {
        ListSection(style: service.themeStyle) {
            VStack(alignment: .center, spacing: 10) {
                HStack(alignment: .top) {
                    Spacer()
                    if let native = network.nativeBalance,
                       let balance = Double(native),
                       let formatted = (balance / Constants.eighteenDecimal),
                       let roundedValue = formatted.truncate(places: 4),
                       let networkFormated = network.network?.formatNetwork() {
                        HStack(alignment: .center, spacing: 2) {
                            Text("".forTrailingZero(temp: roundedValue)).fontTemplate(DefaultTemplate.gasPriceFont)

                            Text(networkFormated).fontTemplate(DefaultTemplate.body_standard)
                        }
                    }
                }

                LightChartView(data: [2, 17, 9, 23, 10, 8],
                               type: .curved,
                               visualType: .filled(color: store.getNetworkColor(network.network ?? ""), lineWidth: 3),
                               offset: 0.2,
                               currentValueLineType: .none)
                        .frame(width: 120, height: 40, alignment: .center)
                        .padding(.horizontal, 2.5)

                HStack(alignment: .center) {
                    Image((network.network == "bsc" ? "binance": network.network ?? "") + "_logo")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 34, height: 34, alignment: .center)
                        .clipShape(Circle())

                    Text(network.network?.capitalized ?? "").fontTemplate(DefaultTemplate.subheadingSemiBold)
                    Spacer()
                }

                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 2) {
                        if let tokenCount = network.tokenBalance?.count, tokenCount != 0 {
                            Text("+\(tokenCount) tokens")
                                .fontTemplate(DefaultTemplate.caption)
                        }

                        if let nfts = network.nfts, let nftCount = nfts.result?.count, nftCount != 0 {
                            Text("+\(nftCount) collectables")
                                .fontTemplate(DefaultTemplate.caption)
                        }
                    }

                    Spacer()
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
        }
    }

}
