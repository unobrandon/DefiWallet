//
//  CollectableSeeAllCell.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 4/12/22.
//

import SwiftUI

struct CollectableSeeAllCell: View {

    private let style: AppStyle
    private let action: () -> Void

    init(style: AppStyle, action: @escaping () -> Void) {
        self.style = style
        self.action = action
    }

    var body: some View {
        Button(action: { action() }, label: {
            ListSection(hasPadding: false, style: style) {
                VStack(alignment: .center, spacing: 10) {
                    Image(systemName: "arrow.right.circle")
                        .resizable()
                        .font(Font.title.weight(.regular))
                        .scaledToFit()
                        .frame(width: 24, height: 24, alignment: .center)
                        .foregroundColor(.secondary)

                    Text("see all").fontTemplate(DefaultTemplate.bodySemibold_nunito_secondary)
                }.frame(maxWidth: .infinity, alignment: .center)
                .padding(.vertical, 30)
            }
        }).buttonStyle(ClickInteractiveStyle(0.99))
    }

}
