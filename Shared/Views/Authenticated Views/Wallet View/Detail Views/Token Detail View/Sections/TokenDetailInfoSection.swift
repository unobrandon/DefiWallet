//
//  TokenDetailInfoSection.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 5/25/22.
//

import SwiftUI

extension TokenDetailView {

    // MARK: Token Details Overview Section

    @ViewBuilder
    func detailsInfoSection() -> some View {
        ListSection(title: "More Info", hasPadding: true, style: service.themeStyle) {
            if let description = tokenDescriptor?.tokenDescription, !description.isEmpty {
                VStack(alignment: .leading) {
                    ViewMoreText(description, isCaption: false)
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

            if let country = tokenDescriptor?.countryOrigin {
                ListInfoSmallView(title: "Country", info: country, secondaryInfo: nil, style: service.themeStyle, isLast: false)
            }

            if let est = tokenDescriptor?.genesisDate {
                ListInfoSmallView(title: "Established", info: est, secondaryInfo: nil, style: service.themeStyle, isLast: false)
            }

            if let projectURL = tokenDescriptor?.projectURL {
                ListStandardButton(title: "Project Link", systemImage: "safari", isLast: false, hasHaptic: false, style: service.themeStyle, action: {
                    print("open project url here \(projectURL)")
                })
            }
        }
    }

}
