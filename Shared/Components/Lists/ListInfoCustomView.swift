//
//  ListInfoCustomView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 3/21/22.
//

import SwiftUI

struct ListInfoCustomView<Content: View>: View {

    private let content: Content
    private let title: String
    private let style: AppStyle
    private let isLast: Bool

    init(title: String, style: AppStyle, isLast: Bool, @ViewBuilder _ content: () -> Content) {
        self.title = title
        self.style = style
        self.isLast = isLast
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .trailing, spacing: 0) {
            HStack(alignment: .center) {
                Text(title).fontTemplate(DefaultTemplate.bodySemibold_nunito_secondary)

                Spacer()
                content
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
