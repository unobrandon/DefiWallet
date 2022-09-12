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
                        tokenNetworkCell(name: "Ethereum", address: eth, action: { address in
                            UIPasteboard.general.string = eth
                            HapticFeedback.successHapticFeedback()
                            showNotiHUD(image: "doc.on.doc", color: Color("AccentColor"), title: "Copied ethereum address", subtitle: eth.formatAddress(6))
                        })
                    }

                    if let polygon = allAddresses.polygon_pos {
                        tokenNetworkCell(name: "Polygon", address: polygon, action: { address in
                            UIPasteboard.general.string = polygon
                            HapticFeedback.successHapticFeedback()
                            showNotiHUD(image: "doc.on.doc", color: Color("AccentColor"), title: "Copied polygon address", subtitle: polygon.formatAddress(6))
                        })
                    }

                    if let bnb = allAddresses.binance {
                        tokenNetworkCell(name: "Binance", address: bnb, action: { address in
                            UIPasteboard.general.string = bnb
                            HapticFeedback.successHapticFeedback()
                            showNotiHUD(image: "doc.on.doc", color: Color("AccentColor"), title: "Copied binance address", subtitle: bnb.formatAddress(6))
                        })
                    }

                    if let avax = allAddresses.avalanche {
                        tokenNetworkCell(name: "Avalanche", address: avax, action: { address in
                            UIPasteboard.general.string = avax
                            HapticFeedback.successHapticFeedback()
                            showNotiHUD(image: "doc.on.doc", color: Color("AccentColor"), title: "Copied avalanche address", subtitle: avax.formatAddress(6))
                        })
                    }

                    if let fantom = allAddresses.fantom {
                        tokenNetworkCell(name: "Fantom", address: fantom, action: { address in
                            UIPasteboard.general.string = fantom
                            HapticFeedback.successHapticFeedback()
                            showNotiHUD(image: "doc.on.doc", color: Color("AccentColor"), title: "Copied fantom address", subtitle: fantom.formatAddress(6))
                        })
                    }

                    if let xdai = allAddresses.xdai {
                        tokenNetworkCell(name: "xDAI", address: xdai, action: { address in
                            UIPasteboard.general.string = xdai
                            HapticFeedback.successHapticFeedback()
                            showNotiHUD(image: "doc.on.doc", color: Color("AccentColor"), title: "Copied xDAI address", subtitle: xdai.formatAddress(6))
                        })
                    }

                    if let solana = allAddresses.solana {
                        tokenNetworkCell(name: "Solana", address: solana, action: { address in
                            UIPasteboard.general.string = solana
                            HapticFeedback.successHapticFeedback()
                            showNotiHUD(image: "doc.on.doc", color: Color("AccentColor"), title: "Copied solana address", subtitle: solana.formatAddress(6))
                        })
                    }

                    if let moonriver = allAddresses.moonriver {
                        tokenNetworkCell(name: "Moonriver", address: moonriver, action: { address in
                            UIPasteboard.general.string = moonriver
                            HapticFeedback.successHapticFeedback()
                            showNotiHUD(image: "doc.on.doc", color: Color("AccentColor"), title: "Copied moonriver address", subtitle: moonriver.formatAddress(6))
                        })
                    }

                    if let moonbeam = allAddresses.moonbeam {
                        tokenNetworkCell(name: "Moonbeam", address: moonbeam, action: { address in
                            UIPasteboard.general.string = moonbeam
                            HapticFeedback.successHapticFeedback()
                            showNotiHUD(image: "doc.on.doc", color: Color("AccentColor"), title: "Copied moonbeam address", subtitle: moonbeam.formatAddress(6))
                        })
                    }

                    if let huobi = allAddresses.huobi_token {
                        tokenNetworkCell(name: "Huobi Token", address: huobi, action: { address in
                            UIPasteboard.general.string = huobi
                            HapticFeedback.successHapticFeedback()
                            showNotiHUD(image: "doc.on.doc", color: Color("AccentColor"), title: "Copied huobi token address", subtitle: huobi.formatAddress(6))
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
                    .overlay(Circle().foregroundColor(.clear).overlay(Circle().stroke(Color("baseBackground_bordered"), lineWidth: 1)))
                    .padding(.leading, 10)

                VStack(alignment: .leading, spacing: 2) {
                    HStack(alignment: .center, spacing: 0) {
                        Text(name)
                            .fontTemplate(DefaultTemplate.bodyMedium)
                        Spacer()

                        Image(systemName: "doc.on.doc")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.secondary)
                            .frame(width: 12, height: 12, alignment: .center)
                    }

                    Text(address.formatAddress(6))
                        .fontTemplate(DefaultTemplate.caption_micro_Mono_secondary)
                        .lineLimit(1)
                }
                Spacer()
            }
            .padding(.vertical, 8)
            .background(RoundedRectangle(cornerRadius: 6, style: .circular)
                .foregroundColor(Color("baseButton_selected")))
            .foregroundColor(Color("baseButton_selected"))
        })
        .buttonStyle(ClickInteractiveStyle(0.98))
    }

}
