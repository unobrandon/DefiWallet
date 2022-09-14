//
//  TokenListSmallCell.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 4/3/22.
//

import SwiftUI

struct TrendingTokenListCell: View {

    @ObservedObject private var service: AuthenticatedServices

    private let data: TrendingItem
    private let style: AppStyle
    private let action: (TrendingItem) -> Void

    init(service: AuthenticatedServices, data: TrendingItem, style: AppStyle, action: @escaping (TrendingItem) -> Void) {
        self.service = service
        self.data = data
        self.style = style
        self.action = action
    }

    var body: some View {
        Button(action: {
            action(data)

            #if os(iOS)
                HapticFeedback.rigidHapticFeedback()
            #endif
        }, label: {
            HStack(alignment: .center, spacing: 10) {
                Text("\((data.score ?? -1) + 1).)")
                    .fontTemplate(DefaultTemplate.caption_semibold)

                RemoteImage(data.thumb ?? "", size: 24)
                    .clipShape(Circle())
                    .overlay(Circle().strokeBorder(DefaultTemplate.borderColor.opacity(1.0), lineWidth: 1.0))
                    .shadow(color: Color.black.opacity(service.themeStyle == .shadow ? 0.15 : 0.0), radius: 4, x: 0, y: 2)

                Text(data.symbol ?? "")
                    .fontTemplate(DefaultTemplate.bodyMedium)
                    .adjustsFontSizeToFitWidth(true)
                    .minimumScaleFactor(0.8)
                    .lineLimit(1)

//                VStack(alignment: .leading, spacing: 0) {
//                    Text(data.name ?? "")
//                        .fontTemplate(DefaultTemplate.bodyMedium)
//                        .adjustsFontSizeToFitWidth(true)
//                        .minimumScaleFactor(0.8)
//                        .lineLimit(2)
//
//                    Text(data.symbol ?? "")
//                        .fontTemplate(DefaultTemplate.caption_micro_Mono_secondary)
//                }

//                if let marketCapRank = data.marketCapRank {
//                    Text("#\(marketCapRank)")
//                        .fontTemplate(DefaultTemplate.caption_micro_Mono)
//                        .minimumScaleFactor(0.925)
//                        .padding(.vertical, 1)
//                        .padding(.horizontal, 4)
//                        .opacity(0.85)
//                        .background(RoundedRectangle(cornerRadius: 3, style: .circular)
//                            .foregroundColor(DefaultTemplate.gray5))
//                }

//                Spacer()
            }
//            .background(RoundedRectangle(cornerRadius: 10, style: .circular)
//                .foregroundColor(Color("AccentColor").opacity(style == .shadow ? 1.0 : 0.15)).frame(height: 40).frame(maxWidth: .infinity))
//            .shadow(color: Color("AccentColor").opacity(style == .shadow ? 0.175 : 0.0),
//                    radius: 4, x: 0, y: 5)
        })
        .buttonStyle(ClickInteractiveStyle(0.99))
    }
}
