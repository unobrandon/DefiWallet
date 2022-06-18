//
//  NetworkDropdownButton.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 5/31/22.
//

import SwiftUI

struct NetworkDropdownButton: View {

    private var style: AppStyle
    private let action: (String) -> Void

    @State var selectedNetwork: String = "Ethereum"
    @State var network: Network = .ethereum

    init(style: AppStyle, action: @escaping (String) -> Void) {
        self.style = style
        self.action = action
    }

    var body: some View {
        Menu {
            Button(action: {
                selectedNetwork = "Ethereum"
                network = .ethereum
                action(selectedNetwork)

                #if os(iOS)
                    HapticFeedback.rigidHapticFeedback()
                #endif
            }, label: { Text("Ethereum") })

            Button(action: {
                selectedNetwork = "Polygon"
                network = .polygon
                action(selectedNetwork)

                #if os(iOS)
                    HapticFeedback.rigidHapticFeedback()
                #endif
            }, label: { Text("Polygon") })

            Button(action: {
                selectedNetwork = "Binance"
                network = .binanceSmartChain
                action(selectedNetwork)

                #if os(iOS)
                    HapticFeedback.rigidHapticFeedback()
                #endif
            }, label: { Text("Binance") })

            Button(action: {
                selectedNetwork = "Avalanche"
                network = .avalanche
                action(selectedNetwork)

                #if os(iOS)
                    HapticFeedback.rigidHapticFeedback()
                #endif
            }, label: { Text("Avalanche") })

            Button(action: {
                selectedNetwork = "Fantom"
                network = .fantom
                action(selectedNetwork)

                #if os(iOS)
                    HapticFeedback.rigidHapticFeedback()
                #endif
            }, label: { Text("Fantom") })
        } label: {
            HStack(alignment: .center, spacing: 7.5) {
                getNetworkImage(network)
                    .resizable()
                    .sizeToFit()
                    .frame(height: 20, alignment: .center)

                Text(selectedNetwork)
                    .fontTemplate(FontTemplate(font: Font.custom("Poppins-Medium", size: 14), weight: .medium, foregroundColor: Color.primary, lineSpacing: 1))
                    .lineLimit(1)

                Image(systemName: "chevron.down")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 15, height: 8)
                    .foregroundColor(Color.secondary)
                    .padding(.leading, 10)
            }
            .padding(.horizontal, 10)
//            .background(RoundedRectangle(cornerRadius: 10, style: .circular)
//                            .strokeBorder(DefaultTemplate.borderColor.opacity(style == .border ? 1.0 : 0.0), lineWidth: 1.5).frame(height: 40).background(style == .shadow ? Color("baseButton") : Color.clear).cornerRadius(10))
//            .shadow(color: Color.black.opacity(style == .shadow ? 0.175 : 0.0),
//                    radius: 6)
        }
        .buttonStyle(ClickInteractiveStyle(0.95))
    }

    func getNetworkImage(_ network: Network) -> Image {
        switch network {
        case .ethereum:
            return Image("eth_logo")
        case .polygon:
            return Image("polygon_logo")
        case .binanceSmartChain:
            return Image("binance_logo")
        case .avalanche:
            return Image("avalanche_logo")
        case .fantom:
            return Image("fantom_logo")
        }
    }

}
