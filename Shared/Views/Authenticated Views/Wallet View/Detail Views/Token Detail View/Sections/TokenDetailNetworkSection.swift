//
//  TokenDetailNetworkSection.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 9/12/22.
//

import SwiftUI

extension TokenDetailView {

    // MARK: Token Details About Section

    /*
    @ViewBuilder
    func detailsNetworksSection() -> some View {
        if let allAddresses = tokenModel?.allAddress ?? tokenDetails?.allAddress ?? tokenDescriptor?.allAddress {
            VStack(alignment: .leading, spacing: 5) {
                ListTitleView(title: "Networks", showDivider: false, style: service.themeStyle)

                LazyVGrid(columns: Array(repeating: SwiftUI.GridItem(.flexible(), spacing: 7.5), count: MobileConstants.deviceType == .phone ? 2 : 3), spacing: 7.5) {
                    if let eth = allAddresses.ethereum {
                        tokenNetworkCell(name: "Ethereum", address: eth, action: { _ in
                            copyAction("Ethereum", eth)
                        })
                    }

                    if let polygon = allAddresses.polygon_pos {
                        tokenNetworkCell(name: "Polygon", address: polygon, action: { _ in
                            copyAction("Polygon", polygon)
                        })
                    }

                    if let bnb = allAddresses.binance {
                        tokenNetworkCell(name: "Binance", address: bnb, action: { _ in
                            copyAction("Binance", bnb)
                        })
                    }

                    if let avax = allAddresses.avalanche {
                        tokenNetworkCell(name: "Avalanche", address: avax, action: { _ in
                            copyAction("Avalanche", avax)
                        })
                    }

                    if let fantom = allAddresses.fantom {
                        tokenNetworkCell(name: "Fantom", address: fantom, action: { _ in
                            copyAction("Fantom", fantom)
                        })
                    }

                    if let xdai = allAddresses.xdai {
                        tokenNetworkCell(name: "xDAI", address: xdai, action: { _ in
                            copyAction("xDAI", xdai)
                        })
                    }

                    if let solana = allAddresses.solana {
                        tokenNetworkCell(name: "Solana", address: solana, action: { _ in
                            copyAction("Solana", solana)
                        })
                    }

                    if let moonriver = allAddresses.moonriver {
                        tokenNetworkCell(name: "Moonriver", address: moonriver, action: { _ in
                            copyAction("Moonriver", moonriver)
                        })
                    }

                    if let moonbeam = allAddresses.moonbeam {
                        tokenNetworkCell(name: "Moonbeam", address: moonbeam, action: { _ in
                            copyAction("Moonbeam", moonbeam)
                        })
                    }

                    if let huobi = allAddresses.huobi_token {
                        tokenNetworkCell(name: "Huobi Token", address: huobi, action: { _ in
                            copyAction("Huobi Token", huobi)
                        })
                    }

//                    if let kucoin = allAddresses.kucoin {
//                        tokenNetworkCell(name: "KuCoin", address: kucoin, action: { _ in
//                            copyAction("KuCoin", kucoin)
//                        })
//                    }

//                    if let arbitrum = allAddresses.arbitrum {
//                        tokenNetworkCell(name: "Arbitrum", address: arbitrum, action: { _ in
//                            copyAction("Arbitrum", arbitrum)
//                        })
//                    }
//
//                    if let okex = allAddresses.okex {
//                        tokenNetworkCell(name: "OKExChain", address: okex, action: { _ in
//                            copyAction("OKExChain", okex)
//                        })
//                    }

//                    if let cronos = allAddresses.cronos {
//                        tokenNetworkCell(name: "Crypto.com", address: cronos, action: { _ in
//                            copyAction("Crypto.com", cronos)
//                        })
//                    }
//
//                    if let harmony = allAddresses.harmony {
//                        tokenNetworkCell(name: "Harmony", address: harmony, action: { _ in
//                            copyAction("Harmony", harmony)
//                        })
//                    }
                }
                .padding(.horizontal)
            }
            .padding(.bottom, 10)
        }
    }
    */

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
                    .overlay(Circle().strokeBorder(DefaultTemplate.borderColor.opacity(0.8), lineWidth: 1))
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
                .foregroundColor(Color("baseButton")))
            .foregroundColor(Color("baseButton"))
            .shadow(color: Color.black.opacity(service.themeStyle == .shadow ? 0.15 : 0.0), radius: 5, x: 0, y: 3)
            .overlay(RoundedRectangle(cornerRadius: 6, style: .circular).strokeBorder(DefaultTemplate.borderColor, lineWidth: service.themeStyle == .shadow ? 1.0 : 1.35))
        })
        .buttonStyle(ClickInteractiveStyle(0.98))
    }

    private func copyAction(_ name: String, _ address: String) {
        UIPasteboard.general.string = address
        HapticFeedback.successHapticFeedback()
        showNotiHUD(image: "doc.on.doc", color: Color("AccentColor"), title: "Copied \(name) address", subtitle: address.formatAddress(8))
    }

}
