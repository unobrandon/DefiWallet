//
//  MultipleLinksView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 9/11/22.
//

import SwiftUI

struct MultipleLinksView: View {

    @ObservedObject private var service: AuthenticatedServices
    @ObservedObject private var store: MarketsService
    let title: String
    let links: [String?]
    var action: (String) -> Void

    init(title: String, links: [String?], service: AuthenticatedServices, action: @escaping (String) -> Void) {
        self.service = service
        self.store = service.market
        self.title = title
        self.links = links
        self.action = action
    }

    var body: some View {
        VStack(alignment: .center) {
            HStack(alignment: .center, spacing: 0) {
                Text(title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)

                Spacer()
            }
            .padding(.bottom)

            ListSection(title: "Additional Links", hasPadding: false, style: service.themeStyle) {
                ForEach(links, id: \.self) { link in
                    if let link = link, link != "" {
                        ListStandardButton(title: link, isLast: false, hasHaptic: false, style: service.themeStyle, action: {
                            action(link)
                        })
                    }
                }
            }
        }
    }
}
