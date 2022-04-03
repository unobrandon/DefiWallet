//
//  ListTitleView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 4/3/22.
//

import SwiftUI

struct ListTitleView: View {

    private let title: String
    private let actionText: String?
    private let style: AppStyle

    init(title: String, actionText: String? = "", style: AppStyle) {
        self.title = title
        self.actionText = actionText
        self.style = style
    }

    var body: some View {
        VStack(alignment: .trailing, spacing: 0) {
            HStack(alignment: .center) {
                Text(title).fontTemplate(DefaultTemplate.sectionHeader_semibold)

                Spacer()
                if let text = actionText {
                    Text(text).fontTemplate(DefaultTemplate.bodyRegular_accent_standard)
                }

                Image(systemName: "chevron.right")
                    .resizable()
                    .font(Font.title.weight(.bold))
                    .scaledToFit()
                    .frame(width: 7, height: 15, alignment: .center)
                    .foregroundColor(Color("AccentColor"))
            }
            .padding(.vertical, 10)
            .padding(.horizontal)

            if style == .shadow {
                Divider().padding(.leading)
            } else if style == .border {
                Rectangle().foregroundColor(DefaultTemplate.borderColor)
                    .frame(height: 1)
            }
        }
        .frame(minWidth: 100, maxWidth: .infinity)
    }

}
