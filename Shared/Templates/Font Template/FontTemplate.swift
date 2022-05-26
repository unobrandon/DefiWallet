//
//  FontTemplate.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/14/22.
//

import SwiftUI

public struct FontTemplate: FontTemplating {

    public init(font: Font,
                weight: Font.Weight,
                foregroundColor: Color,
                italic: Bool = false,
                lineSpacing: CGFloat = 10.0) {

        self.id = UUID()
        self.font = font
        self.weight = weight
        self.foregroundColor = foregroundColor
        self.italic = italic
        self.lineSpacing = lineSpacing

    }

    var id: UUID
    public var font: Font
    public var weight: Font.Weight
    public var foregroundColor: Color
    public var italic: Bool
    public var lineSpacing: CGFloat

}
