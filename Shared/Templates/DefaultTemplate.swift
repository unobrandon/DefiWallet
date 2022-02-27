//
//  DefaultTemplate.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/15/22.
//

import SwiftUI

struct DefaultTemplate {

    static let title = FontTemplate(font: Font.system(size: 32.0), weight: .bold, foregroundColor: .primary, lineSpacing: 0)

    static let heading = FontTemplate(font: Font.system(size: 24.0), weight: .semibold, foregroundColor: .primary, lineSpacing: 8)

    static let subheading = FontTemplate(font: Font.system(size: 18.0), weight: .medium, foregroundColor: .primary, lineSpacing: 6)

    static let body = FontTemplate(font: Font.system(size: 14.0), weight: .regular, foregroundColor: .primary, lineSpacing: 4)

    static let caption = FontTemplate(font: Font.system(size: 12.0), weight: .regular, foregroundColor: .secondary, lineSpacing: 2)

    static var systemBackgroundColor: Color = {
        #if targetEnvironment(macCatalyst)
        return Color(NSColor.controlBackgroundColor)
        #elseif os(macOS)
        return Color(NSColor.controlBackgroundColor)
        #elseif os(iOS)
        return Color(UIColor.systemBackground)
        #endif
    }()

    static var borderColor: Color = {
        #if targetEnvironment(macCatalyst)
        return Color(NSColor.systemGray4)
        #elseif os(macOS)
        return Color(NSColor.systemGray4)
        #elseif os(iOS)
        return Color(.systemGray4)
        #endif
    }()

    static var disabledGray: Color = {
        #if targetEnvironment(macCatalyst)
        return Color(NSColor.systemGray3)
        #elseif os(macOS)
        return Color(NSColor.systemGray3)
        #elseif os(iOS)
        return Color(.systemGray3)
        #endif
    }()

}
