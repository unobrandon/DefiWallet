//
//  StandardSystemImage.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 3/21/22.
//

import SwiftUI

struct StandardSystemImage: View {

    private let systemImage: String
    private let size: CGFloat
    private let color: Color
    private let cornerRadius: CGFloat
    private let style: AppStyle

    init(_ systemImage: String, color: Color, size: CGFloat, cornerRadius: CGFloat, style: AppStyle) {
        self.systemImage = systemImage
        self.color = color
        self.size = size
        self.cornerRadius = cornerRadius
        self.style = style
    }

    var body: some View {
        Image(systemName: systemImage)
            .resizable()
            .sizeToFit()
            .frame(width: size * 0.5, height: size * 0.5, alignment: .center)
            .foregroundColor(style == .shadow ? Color.white : color)
            .background(RoundedRectangle(cornerRadius: cornerRadius, style: .circular)
                            .foregroundColor(color.opacity(style == .shadow ? 1.0 : 0.15)).frame(width: size, height: size))
            .shadow(color: color.opacity(style == .shadow ? 0.175 : 0.0),
                    radius: size > 40 ? (size / 7) : size < 25 ? 3 : 5, x: 0, y: size > 40 ? (size / 8) : size < 25 ? 3 : 5)
    }

}
