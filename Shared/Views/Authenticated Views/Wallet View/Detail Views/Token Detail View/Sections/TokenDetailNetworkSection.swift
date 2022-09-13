//
//  TokenDetailNetworkSection.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 9/12/22.
//

import SwiftUI

extension TokenDetailView {

    // MARK: Token Details About Section

    @ViewBuilder
    func detailsNetworksSection() -> some View {
        if let allAddresses = tokenModel?.allAddress {
            VStack(alignment: .leading, spacing: 10) {
                Text("Networks:")
                    .font(.caption)
                    .fontWeight(.regular)
                    .textCase(.uppercase)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)

                LazyVGrid(columns: Array(repeating: SwiftUI.GridItem(.flexible(), spacing: 7.5), count: MobileConstants.deviceType == .phone ? 2 : 3), spacing: 7.5) {
                    if let eth = allAddresses.ethereum {
                        tokenNetworkCell(name: "Ethereum", address: eth, action: { _ in
                            UIPasteboard.general.string = eth
                            HapticFeedback.successHapticFeedback()
                            showNotiHUD(image: "doc.on.doc", color: Color("AccentColor"), title: "Copied ethereum address", subtitle: eth.formatAddress(8))
                        })
                    }

                    if let polygon = allAddresses.polygon_pos {
                        tokenNetworkCell(name: "Polygon", address: polygon, action: { _ in
                            UIPasteboard.general.string = polygon
                            HapticFeedback.successHapticFeedback()
                            showNotiHUD(image: "doc.on.doc", color: Color("AccentColor"), title: "Copied polygon address", subtitle: polygon.formatAddress(8))
                        })
                    }

                    if let bnb = allAddresses.binance {
                        tokenNetworkCell(name: "Binance", address: bnb, action: { _ in
                            UIPasteboard.general.string = bnb
                            HapticFeedback.successHapticFeedback()
                            showNotiHUD(image: "doc.on.doc", color: Color("AccentColor"), title: "Copied binance address", subtitle: bnb.formatAddress(8))
                        })
                    }

                    if let avax = allAddresses.avalanche {
                        tokenNetworkCell(name: "Avalanche", address: avax, action: { _ in
                            UIPasteboard.general.string = avax
                            HapticFeedback.successHapticFeedback()
                            showNotiHUD(image: "doc.on.doc", color: Color("AccentColor"), title: "Copied avalanche address", subtitle: avax.formatAddress(8))
                        })
                    }

                    if let fantom = allAddresses.fantom {
                        tokenNetworkCell(name: "Fantom", address: fantom, action: { _ in
                            UIPasteboard.general.string = fantom
                            HapticFeedback.successHapticFeedback()
                            showNotiHUD(image: "doc.on.doc", color: Color("AccentColor"), title: "Copied fantom address", subtitle: fantom.formatAddress(8))
                        })
                    }

                    if let xdai = allAddresses.xdai {
                        tokenNetworkCell(name: "xDAI", address: xdai, action: { _ in
                            UIPasteboard.general.string = xdai
                            HapticFeedback.successHapticFeedback()
                            showNotiHUD(image: "doc.on.doc", color: Color("AccentColor"), title: "Copied xDAI address", subtitle: xdai.formatAddress(8))
                        })
                    }

                    if let solana = allAddresses.solana {
                        tokenNetworkCell(name: "Solana", address: solana, action: { _ in
                            UIPasteboard.general.string = solana
                            HapticFeedback.successHapticFeedback()
                            showNotiHUD(image: "doc.on.doc", color: Color("AccentColor"), title: "Copied solana address", subtitle: solana.formatAddress(8))
                        })
                    }

                    if let moonriver = allAddresses.moonriver {
                        tokenNetworkCell(name: "Moonriver", address: moonriver, action: { _ in
                            UIPasteboard.general.string = moonriver
                            HapticFeedback.successHapticFeedback()
                            showNotiHUD(image: "doc.on.doc", color: Color("AccentColor"), title: "Copied moonriver address", subtitle: moonriver.formatAddress(8))
                        })
                    }

                    if let moonbeam = allAddresses.moonbeam {
                        tokenNetworkCell(name: "Moonbeam", address: moonbeam, action: { _ in
                            UIPasteboard.general.string = moonbeam
                            HapticFeedback.successHapticFeedback()
                            showNotiHUD(image: "doc.on.doc", color: Color("AccentColor"), title: "Copied moonbeam address", subtitle: moonbeam.formatAddress(8))
                        })
                    }

                    if let huobi = allAddresses.huobi_token {
                        tokenNetworkCell(name: "Huobi Token", address: huobi, action: { _ in
                            UIPasteboard.general.string = huobi
                            HapticFeedback.successHapticFeedback()
                            showNotiHUD(image: "doc.on.doc", color: Color("AccentColor"), title: "Copied huobi token address", subtitle: huobi.formatAddress(8))
                        })
                    }
                }
                .padding(.horizontal, 5)
            }
            .padding(.bottom, 30)
            .padding(.horizontal)
        }
    }

    @ViewBuilder
    func tokenNetworkCell(name: String, address: String, action: @escaping (String) -> Void) -> some View {
        Button(action: {
            action(address)
        }, label: {
            HStack(alignment: .center, spacing: 10) {
                service.wallet.getNetworkTransactImage(name.lowercased())
                    .resizable()
                    .scaledToFill()
                    .frame(width: 25, height: 25, alignment: .center)
                    .clipShape(Circle())
                    .padding(.leading, 10)

                VStack(alignment: .leading, spacing: 0) {
                    HStack(alignment: .center, spacing: 0) {
                        Text(name)
                            .fontTemplate(DefaultTemplate.bodyMedium)
                        Spacer()

                        Image(systemName: "doc.on.doc")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.secondary)
                            .frame(height: 12, alignment: .center)
                    }

                    Text(address.formatAddress(6))
                        .fontTemplate(DefaultTemplate.caption_micro_Mono_secondary)
                        .lineLimit(1)
                }
                Spacer()
            }
            .padding(.vertical, 5)
            .background(RoundedRectangle(cornerRadius: 6, style: .circular)
                .foregroundColor(Color("baseButton_selected")))
            .foregroundColor(Color("baseButton_selected"))
        })
        .buttonStyle(ClickInteractiveStyle(0.98))
    }

}
