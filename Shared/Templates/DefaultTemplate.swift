//
//  DefaultTemplate.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/15/22.
//

import SwiftUI

struct DefaultTemplates {

    static let title = FontTemplate(font: Font.system(size: 32.0), weight: .bold, foregroundColor: .primary, lineSpacing: 0)

    static let heading = FontTemplate(font: Font.system(size: 24.0), weight: .semibold, foregroundColor: .primary)

    static let subheading = FontTemplate(font: Font.system(size: 18.0), weight: .medium, foregroundColor: .primary)

    static let body = FontTemplate(font: Font.system(size: 14.0), weight: .regular, foregroundColor: .primary)

    static let caption = FontTemplate(font: Font.system(size: 12.0), weight: .regular, foregroundColor: .secondary)

    static var systemBackgroundColor: Color = {
        #if targetEnvironment(macCatalyst)
        return Color(NSColor.controlBackgroundColor)
        #elseif os(macOS)
        return Color(NSColor.controlBackgroundColor)
        #elseif os(iOS)
        return Color(UIColor.systemBackground)
        #endif
    }()

}
