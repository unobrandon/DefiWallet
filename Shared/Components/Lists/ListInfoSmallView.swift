//
//  ListInfoSmallView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 4/18/22.
//

import SwiftUI

struct ListInfoSmallView: View {

    private let title: String
    private let info: String
    private let secondaryInfo: String?
    private let style: AppStyle
    private let isLast: Bool

    init(title: String, info: String, secondaryInfo: String? = nil, style: AppStyle, isLast: Bool) {
        self.title = title
        self.info = info
        self.secondaryInfo = secondaryInfo ?? nil
        self.style = style
        self.isLast = isLast
    }

    var body: some View {
        VStack(alignment: .trailing, spacing: 0) {
            HStack(alignment: .center, spacing: 5) {
                Text(title).fontTemplate(DefaultTemplate.bodySemibold)

                Spacer()
                Text(info)
                    .fontTemplate(DefaultTemplate.sectionHeader_semibold)

                if let secondaryInfo = secondaryInfo {
                    Text(secondaryInfo.lowercased())
                        .fontTemplate(DefaultTemplate.body_secondary)
                        .multilineTextAlignment(.trailing)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 10)

            if style == .shadow, !isLast {
                Divider().padding(.leading)
            } else if style == .border, !isLast {
                Rectangle().foregroundColor(DefaultTemplate.borderColor)
                    .frame(height: 1)
            }
        }
        .frame(minWidth: 100, maxWidth: .infinity)
    }

}
