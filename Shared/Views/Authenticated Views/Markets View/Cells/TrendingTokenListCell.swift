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

    init(service: AuthenticatedServices, data: TrendingItem, style: AppStyle) {
        self.service = service
        self.data = data
        self.style = style
    }

    var body: some View {
        VStack(alignment: .trailing, spacing: 0) {
            HStack(alignment: .center, spacing: 5) {
                Text("\((data.score ?? -1) + 1)")
                    .fontTemplate(DefaultTemplate.caption_semibold)

                RemoteImage(data.thumb ?? "", size: 20)
                    .clipShape(Circle())
                    .overlay(Circle().strokeBorder(DefaultTemplate.borderColor.opacity(1.0), lineWidth: 1.0))
                    .shadow(color: Color.black.opacity(service.themeStyle == .shadow ? 0.15 : 0.0), radius: 4, x: 0, y: 2)
                    .padding(.leading, 2.5)

                Text(data.name ?? "").fontTemplate(DefaultTemplate.bodyMedium)

                Text(data.symbol ?? "").fontTemplate(DefaultTemplate.body_secondary)

                Spacer()
                Text("#\(data.marketCapRank ?? 0)").fontTemplate(DefaultTemplate.caption)
            }
            .padding(.vertical, 5)
            .padding(.horizontal)
        }
        .frame(minWidth: 100, maxWidth: .infinity)
    }

}
