//
//  DefaultTemplate.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/15/22.
//

import SwiftUI

struct DefaultTemplate {

    static let title = FontTemplate(font: Font.system(size: 32.0), weight: .bold, foregroundColor: .primary, lineSpacing: 6)
    static let titleSemibold = FontTemplate(font: Font.system(size: 32.0), weight: .semibold, foregroundColor: .primary, lineSpacing: 6)
    static let titleMedium = FontTemplate(font: Font.system(size: 32.0), weight: .medium, foregroundColor: .primary, lineSpacing: 6)
    static let titleRegular = FontTemplate(font: Font.system(size: 32.0), weight: .regular, foregroundColor: .primary, lineSpacing: 6)

    static let heading = FontTemplate(font: Font.system(size: 24.0), weight: .semibold, foregroundColor: .primary, lineSpacing: 5)

    static let subheading = FontTemplate(font: Font.system(size: 18.0), weight: .medium, foregroundColor: .primary, lineSpacing: 4)
    static let subheadingBold = FontTemplate(font: Font.system(size: 18.0), weight: .bold, foregroundColor: .primary, lineSpacing: 4)
    static let subheadingSemiBold = FontTemplate(font: Font.system(size: 18.0), weight: .semibold, foregroundColor: .primary, lineSpacing: 4)
    static let subheadingMedium = FontTemplate(font: Font.system(size: 18.0), weight: .medium, foregroundColor: .primary, lineSpacing: 4)
    static let subheadingRegular = FontTemplate(font: Font.system(size: 18.0), weight: .regular, foregroundColor: .primary, lineSpacing: 4)

    static let body = FontTemplate(font: Font.system(size: 14.0), weight: .regular, foregroundColor: .primary, lineSpacing: 2)
    static let bodyBold = FontTemplate(font: Font.system(size: 14.0), weight: .bold, foregroundColor: .primary, lineSpacing: 2)
    static let bodySemibold = FontTemplate(font: Font.system(size: 14.0), weight: .semibold, foregroundColor: .primary, lineSpacing: 2)
    static let bodyMedium = FontTemplate(font: Font.system(size: 14.0), weight: .medium, foregroundColor: .primary, lineSpacing: 2)

    static let caption = FontTemplate(font: Font.system(size: 12.0), weight: .regular, foregroundColor: .secondary, lineSpacing: 2)
    static let captionError = FontTemplate(font: Font.system(size: 12.0), weight: .regular, foregroundColor: .red, lineSpacing: 2)

    static let alertMessage = FontTemplate(font: Font.system(size: 12.0), weight: .semibold, foregroundColor: .white, lineSpacing: 0)

    static let monospace = FontTemplate(font: Font.system(.caption, design: .monospaced), weight: .regular, foregroundColor: .primary, lineSpacing: 2)
    static let monospaceBody = FontTemplate(font: Font.system(size: 14.0, design: .monospaced), weight: .semibold, foregroundColor: .primary, lineSpacing: 2)
    static let monospaceBold = FontTemplate(font: Font.system(.caption, design: .monospaced), weight: .bold, foregroundColor: .primary, lineSpacing: 2)
    static let monospaceSemibold = FontTemplate(font: Font.system(.caption, design: .monospaced), weight: .semibold, foregroundColor: .primary, lineSpacing: 2)

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
