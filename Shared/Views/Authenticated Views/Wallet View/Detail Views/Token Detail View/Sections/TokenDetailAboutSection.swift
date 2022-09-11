//
//  TokenDetailAboutSection.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 5/25/22.
//

import SwiftUI

extension TokenDetailView {

    // MARK: Token Details About Section

    @ViewBuilder
    func detailsAboutSection() -> some View {
        ListSection(title: "About", hasPadding: true, style: service.themeStyle) {
            if let description = tokenDescriptor?.tokenDescription ?? tokenModel?.description ?? tokenDetails?.tokenDescription, !description.isEmpty {
                VStack(alignment: .leading) {
                    ViewMoreText(description, isCaption: false, lineLimit: 5)
                }
                .padding(.horizontal)
                .padding(.vertical, 10)

                if service.themeStyle == .shadow {
                    Divider().padding(.leading)
                } else if service.themeStyle == .border {
                    Rectangle().foregroundColor(DefaultTemplate.borderColor)
                        .frame(height: 1)
                }
            }

            if let country = tokenDescriptor?.countryOrigin ?? tokenModel?.countryOrigin ?? tokenDetails?.countryOrigin, !country.isEmpty {
                ListInfoSmallView(title: "Country", info: country, secondaryInfo: nil, style: service.themeStyle, isLast: false)
            }

            if let est = tokenDescriptor?.genesisDate ?? tokenModel?.genesisDate ?? tokenDetails?.genesisDate, !est.isEmpty {
                ListInfoSmallView(title: "Established", info: est, secondaryInfo: nil, style: service.themeStyle, isLast: false)
            }
        }
    }

}
