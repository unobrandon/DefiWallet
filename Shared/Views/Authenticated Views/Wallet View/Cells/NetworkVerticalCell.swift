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
        Button(action: {
            self.actionTap()
        }, label: {
            ListSection(hasPadding: false, removeShadow: true, style: service.themeStyle) {
                VStack(alignment: .leading, spacing: 2.5) {
                    HStack(alignment: .top) {
                        Image((network.network == "bsc" ? "binance" : network.network ?? "") + "_logo")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 38, height: 38, alignment: .center)
                            .clipShape(Circle())
                            .overlay(Circle().strokeBorder(DefaultTemplate.borderColor.opacity(service.themeStyle == .border ? 1.0 : 0.0), lineWidth: 1))
                            .shadow(color: Color.black.opacity(service.themeStyle == .shadow ? 0.15 : 0.0), radius: 8, x: 0, y: 6)

                        Spacer()
                        Image(systemName: "chevron.right")
                            .resizable()
                            .font(Font.title.weight(.semibold))
                            .scaledToFit()
                            .frame(width: 7, height: 14, alignment: .center)
                            .foregroundColor(.secondary)
                    }
                    .padding(.bottom, 2)

                    Text(network.network == "eth" ? "Ethereum" : network.network == "bsc" ? "Binanace" : network.network?.capitalized ?? "")
                        .fontTemplate(DefaultTemplate.subheadingSemiBold)

                    HStack(alignment: .center, spacing: 0) {
                        Text(Locale.current.currencySymbol ?? "").fontTemplate(DefaultTemplate.bodySemibold_Nunito)

                        MovingNumbersView(number: network.totalBalance ?? 0.00,
                                          numberOfDecimalPlaces: 2,
                                          fixedWidth: nil,
                                          theme: DefaultTemplate.bodySemibold_Nunito,
                                          showComma: true) { str in
                            Text(str).fontTemplate(DefaultTemplate.bodySemibold_Nunito)
                        }
                    }.mask(AppGradients.movingNumbersMask)

                    if let native = network.nativeBalance?.nativeBalance,
                       let roundedValue = native.truncate(places: 4),
                       let networkFormatted = network.network?.formatNetwork() {
                        HStack(alignment: .center, spacing: 2) {
                            Text("".forTrailingZero(temp: roundedValue)).fontTemplate(DefaultTemplate.caption_semibold)

                            Text(networkFormatted.uppercased()).fontTemplate(DefaultTemplate.caption)
                        }
                    }

                    // Tokens section
                    Text("\(network.tokens?.count ?? 0) tokens")
                        .fontTemplate(DefaultTemplate.caption)

                    // Collectables section
                    Text("\(network.nfts?.allNfts?.count ?? 0) nfts")
                        .fontTemplate(DefaultTemplate.caption)
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
            }
        })
        .contentShape(Rectangle())
        .buttonStyle(ClickInteractiveStyle(0.98))
    }

    private func actionTap() {
        #if os(iOS)
            HapticFeedback.rigidHapticFeedback()
        #endif

        action()
    }

}
