//
//  ProminentRoundedLabel.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 3/25/22.
//

import SwiftUI

struct ProminentRoundedLabel: View {

    private let text: String
    private let color: Color
    private let fontSize: CGFloat?
    private var style: AppStyle

    init(text: String, color: Color, fontSize: CGFloat? = 14.0, style: AppStyle) {
        self.text = text
        self.fontSize = fontSize ?? 14.0
        self.color = color
        self.style = style
    }

    var body: some View {
        Text(text)
            .fontTemplate(FontTemplate(font: Font.system(size: fontSize ?? 14.0), weight: .semibold, foregroundColor: style == .shadow ? .white : color, lineSpacing: 0))
            .padding(.vertical, 2)
            .padding(.horizontal, 6)
            .background(RoundedRectangle(cornerRadius: 5, style: .circular)
                            .foregroundColor(color.opacity(style == .shadow ? 1.0 : 0.15)))
            .shadow(color: color.opacity(style == .shadow ? 0.175 : 0.0),
                    radius: 5, x: 0, y: 3)
    }
}
