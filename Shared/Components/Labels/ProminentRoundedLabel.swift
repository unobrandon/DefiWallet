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
    private var style: AppStyle

    init(text: String, color: Color, style: AppStyle) {
        self.text = text
        self.color = color
        self.style = style
    }

    var body: some View {
        Text(text)
            .fontTemplate(FontTemplate(font: Font.system(size: 14.0), weight: .semibold, foregroundColor: color, lineSpacing: 0))
            .padding(.vertical, 3)
            .padding(.horizontal, 6)
            .background(RoundedRectangle(cornerRadius: 5, style: .circular)
                            .foregroundColor(color.opacity(style == .shadow ? 1.0 : 0.15)))
            .shadow(color: color.opacity(style == .shadow ? 0.175 : 0.0),
                    radius: 5, x: 0, y: 3)
    }
}
