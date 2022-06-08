//
//  CoinTreasuryDropdownButton.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 6/7/22.
//

import SwiftUI

struct CoinTreasuryDropdownButton: View {

    private var style: AppStyle
    private let action: (PublicTreasuryCoins) -> Void
    @State var coin: PublicTreasuryCoins = .bitcoin

    init(style: AppStyle, action: @escaping (PublicTreasuryCoins) -> Void) {
        self.style = style
        self.action = action
    }

    var body: some View {
        Menu {
            Button(action: {
                coin = .bitcoin
                action(coin)

                #if os(iOS)
                    HapticFeedback.rigidHapticFeedback()
                #endif
            }, label: { Text("Bitcoin") })

            Button(action: {
                coin = .ethereum
                action(coin)

                #if os(iOS)
                    HapticFeedback.rigidHapticFeedback()
                #endif
            }, label: { Text("Ethereum") })
        } label: {
            HStack(alignment: .center, spacing: 7.5) {
                getTreasuryCoinImage(coin)
                    .resizable()
                    .sizeToFit()
                    .frame(height: 18, alignment: .center)

                Text("\(coin.rawValue.capitalized)")
                    .fontTemplate(FontTemplate(font: Font.custom("Poppins-Medium", size: 14), weight: .medium, foregroundColor: Color.primary, lineSpacing: 1))
                    .lineLimit(1)

                Image(systemName: "chevron.down")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .font(Font.title.weight(.bold))
                    .frame(width: 14, height: 8)
                    .foregroundColor(Color.secondary)
                    .padding(.leading, 7.5)
            }
//            .padding(.horizontal, 10)
//            .background(RoundedRectangle(cornerRadius: 10, style: .circular)
//                            .strokeBorder(DefaultTemplate.borderColor.opacity(style == .border ? 1.0 : 0.0), lineWidth: 1.5).frame(height: 40).background(style == .shadow ? Color("baseButton") : Color.clear).cornerRadius(10))
//            .shadow(color: Color.black.opacity(style == .shadow ? 0.175 : 0.0),
//                    radius: 6)
        }
        .buttonStyle(ClickInteractiveStyle(0.95))
    }

    func getTreasuryCoinImage(_ coin: PublicTreasuryCoins) -> Image {
        switch coin {
        case .bitcoin:
            return Image("btc_logo")
        case .ethereum:
            return Image("eth_logo")
        }
    }

}
