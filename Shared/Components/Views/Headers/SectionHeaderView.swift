//
//  SectionHeaderView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 3/14/22.
//

import SwiftUI

struct SectionHeaderView: View {

    private let title: String
    private let subtitle: String?
    private let actionTitle: String?
    private let action: () -> Void?

    init(title: String, subtitle: String? = nil, actionTitle: String? = nil, action: @escaping () -> Void?) {
        self.title = title
        self.subtitle = subtitle
        self.actionTitle = actionTitle
        self.action = action
    }

    var body: some View {
        HStack(alignment: .bottom, spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                Text(title)
                    .fontTemplate(DefaultTemplate.headingSemiBold)
                    .padding(.top)

                if let subtitle = subtitle {
                    Text(subtitle)
                        .fontTemplate(DefaultTemplate.body_secondary)
                }
            }

            Spacer()
            if let actionTitle = actionTitle {
                BorderlessButton(title: actionTitle, size: .small, action: {
                    action()
                })
                .padding(.trailing, 5)
            }
        }
        .padding(.horizontal)
        .padding(.top)
        .padding(.bottom, 10)
    }

}
