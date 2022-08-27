//
//  ListInfoView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 3/21/22.
//

import SwiftUI

struct ListInfoView: View {

    private let title: String
    private let info: String
    private let style: AppStyle
    private let isLast: Bool

    init(title: String, info: String, style: AppStyle, isLast: Bool) {
        self.title = title
        self.info = info
        self.style = style
        self.isLast = isLast
    }

    var body: some View {
        VStack(alignment: .trailing, spacing: 0) {
            HStack(alignment: .center) {
                Text(title).fontTemplate(DefaultTemplate.body_secondary)

                Spacer()
                Text(info)
                    .fontTemplate(DefaultTemplate.bodySemibold)
                    .multilineTextAlignment(.trailing)
            }
            .padding()

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
