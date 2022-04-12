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
        GeometryReader { geo in
            Button(action: { action() }, label: {
                ListSection(hasPadding: false, style: style) {
                    VStack(alignment: .center, spacing: 10) {
                        Image(systemName: "arrow.right.circle")
                            .resizable()
                            .font(Font.title.weight(.regular))
                            .scaledToFit()
                            .frame(width: 24, height: 24, alignment: .center)
                            .foregroundColor(.primary)

                        Text("see all")                                    .fontTemplate(DefaultTemplate.bodySemibold_nunito)
                    }.frame(maxWidth: .infinity, maxHeight: geo.size.width, alignment: .center)
                }
            }).buttonStyle(ClickInteractiveStyle(0.99))
        }
    }

}
