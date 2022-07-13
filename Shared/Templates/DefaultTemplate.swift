//
//  DefaultTemplate.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/15/22.
//

import SwiftUI

struct DefaultTemplate {

    static let titleExtraBold = FontTemplate(font: Font.custom("Poppins-ExtraBold", size: 32), weight: .black, foregroundColor: .primary, lineSpacing: 2)
    static let titleBold = FontTemplate(font: Font.custom("Poppins-Bold", size: 32), weight: .bold, foregroundColor: .primary, lineSpacing: 2)
    static let titleSemiBold = FontTemplate(font: Font.custom("Poppins-SemiBold", size: 32), weight: .semibold, foregroundColor: .primary, lineSpacing: 2)
    static let titleMedium = FontTemplate(font: Font.custom("Poppins-Medium", size: 32), weight: .medium, foregroundColor: .primary, lineSpacing: 2)
    static let titleRegular = FontTemplate(font: Font.custom("Poppins-Regular", size: 32), weight: .regular, foregroundColor: .primary, lineSpacing: 2)
    static let titleLight = FontTemplate(font: Font.custom("Poppins-Light", size: 32), weight: .light, foregroundColor: .primary, lineSpacing: 2)

    static let headingExtraBold = FontTemplate(font: Font.custom("Poppins-ExtraBold", size: 24), weight: .black, foregroundColor: .primary, lineSpacing: 2)
    static let headingBold = FontTemplate(font: Font.custom("Poppins-Bold", size: 24), weight: .bold, foregroundColor: .primary, lineSpacing: 2)
    static let headingSemiBold = FontTemplate(font: Font.custom("Poppins-SemiBold", size: 24), weight: .semibold, foregroundColor: .primary, lineSpacing: 2)
    static let headingMedium = FontTemplate(font: Font.custom("Poppins-Medium", size: 24), weight: .medium, foregroundColor: .primary, lineSpacing: 2)
    static let headingRegular = FontTemplate(font: Font.custom("Poppins-Regular", size: 24), weight: .regular, foregroundColor: .primary, lineSpacing: 2)
    static let headingLight = FontTemplate(font: Font.custom("Poppins-Light", size: 24), weight: .light, foregroundColor: .primary, lineSpacing: 2)

    static let subheadingExtraBold = FontTemplate(font: Font.custom("Poppins-ExtraBold", size: 18), weight: .bold, foregroundColor: .primary, lineSpacing: 2)
    static let subheadingBold = FontTemplate(font: Font.custom("Nunito-Bold", size: 18), weight: .bold, foregroundColor: .primary, lineSpacing: 2)
    static let subheadingBold_black = FontTemplate(font: Font.custom("Nunito-Bold", size: 18), weight: .bold, foregroundColor: .black, lineSpacing: 2)
    static let subheadingSemiBold = FontTemplate(font: Font.custom("Poppins-SemiBold", size: 18), weight: .semibold, foregroundColor: .primary, lineSpacing: 2)
    static let subheadingSemiBold_secondary = FontTemplate(font: Font.custom("Poppins-SemiBold", size: 18), weight: .semibold, foregroundColor: .secondary, lineSpacing: 0)
    static let subheadingMedium = FontTemplate(font: Font.custom("Poppins-Medium", size: 18), weight: .medium, foregroundColor: .primary, lineSpacing: 2)
    static let subheadingMedium_black = FontTemplate(font: Font.custom("Nunito-Medium", size: 18), weight: .medium, foregroundColor: .black, lineSpacing: 2)
    static let subheadingRegular_secondary = FontTemplate(font: Font.custom("Poppins-Regular", size: 18), weight: .regular, foregroundColor: .secondary, lineSpacing: 0)
    static let subheadingRegular = FontTemplate(font: Font.custom("Poppins-Regular", size: 18), weight: .regular, foregroundColor: .primary, lineSpacing: 2)
    static let subheadingLight = FontTemplate(font: Font.custom("Poppins-Light", size: 18), weight: .light, foregroundColor: .primary, lineSpacing: 2)

    static let gasPriceFont = FontTemplate(font: Font.custom("Poppins-SemiBold", size: 16), weight: .semibold, foregroundColor: .primary, lineSpacing: 0)
    static let metricFont = FontTemplate(font: Font.custom("Poppins-SemiBold", size: 14), weight: .medium, foregroundColor: .primary, lineSpacing: 0)
    static let primaryButton = FontTemplate(font: Font.custom("Poppins-Medium", size: 16), weight: .medium, foregroundColor: .white, lineSpacing: 0)

    static let sectionHeader = FontTemplate(font: Font.custom("Nunito-Medium", size: 16), weight: .medium, foregroundColor: .primary, lineSpacing: 0)
    static let sectionHeader_bold = FontTemplate(font: Font.custom("Nunito-Bold", size: 16), weight: .bold, foregroundColor: .primary, lineSpacing: 0)
    static let sectionHeader_bold_white = FontTemplate(font: Font.custom("Nunito-Bold", size: 16), weight: .bold, foregroundColor: .white, lineSpacing: 0)
    static let sectionHeader_semibold = FontTemplate(font: Font.custom("Nunito-Semibold", size: 16), weight: .semibold, foregroundColor: .primary, lineSpacing: 0)
    static let sectionHeader_semibold_white = FontTemplate(font: Font.custom("Nunito-Semibold", size: 16), weight: .semibold, foregroundColor: .white, lineSpacing: 0)
    static let sectionHeader_secondary = FontTemplate(font: Font.custom("Poppins-Medium", size: 16), weight: .medium, foregroundColor: .secondary, lineSpacing: 0)

    static let sectionHeaderBold_nunito = FontTemplate(font: Font.custom("Nunito-Bold", size: 16), weight: .bold, foregroundColor: .primary, lineSpacing: 0)

    static let body = FontTemplate(font: Font.system(size: 14.0), weight: .regular, foregroundColor: .primary, lineSpacing: 1)
    static let bodyBold = FontTemplate(font: Font.system(size: 14.0), weight: .bold, foregroundColor: .primary, lineSpacing: 1)
    static let bodySemibold = FontTemplate(font: Font.system(size: 14.0), weight: .semibold, foregroundColor: .primary, lineSpacing: 1)
    static let bodyMedium = FontTemplate(font: Font.system(size: 14.0), weight: .medium, foregroundColor: .primary, lineSpacing: 1)

    static let body_standard = FontTemplate(font: Font.custom("Poppins-Regular", size: 14), weight: .regular, foregroundColor: .primary, lineSpacing: 1)
    static let bodyBold_standard = FontTemplate(font: Font.custom("Poppins-Bold", size: 14), weight: .bold, foregroundColor: .primary, lineSpacing: 1)
    static let bodySemibold_standard = FontTemplate(font: Font.custom("Poppins-SemiBold", size: 14), weight: .semibold, foregroundColor: .primary, lineSpacing: 1)
    static let bodySemibold_secondary = FontTemplate(font: Font.custom("Poppins-SemiBold", size: 14), weight: .semibold, foregroundColor: .secondary, lineSpacing: 1)
    static let bodySemibold_Nunito = FontTemplate(font: Font.custom("Nunito-Semibold", size: 14), weight: .semibold, foregroundColor: .primary, lineSpacing: 0)
    static let bodyMedium_standard = FontTemplate(font: Font.custom("Poppins-Medium", size: 14), weight: .medium, foregroundColor: .primary, lineSpacing: 1)
    static let bodyMedium_secondary = FontTemplate(font: Font.custom("Poppins-Medium", size: 14), weight: .medium, foregroundColor: .secondary, lineSpacing: 1)
    static let bodyRegular_standard = FontTemplate(font: Font.custom("Poppins-Regular", size: 14), weight: .medium, foregroundColor: .primary, lineSpacing: 1)

    static let bodySemibold_accent_standard = FontTemplate(font: Font.custom("Poppins-SemiBold", size: 14), weight: .semibold, foregroundColor: Color("AccentColor"), lineSpacing: 1)
    static let bodyMedium_accent_standard = FontTemplate(font: Font.custom("Poppins-Medium", size: 14), weight: .medium, foregroundColor: Color("AccentColor"), lineSpacing: 1)
    static let bodyRegular_accent_standard = FontTemplate(font: Font.custom("Poppins-Medium", size: 14), weight: .regular, foregroundColor: Color("AccentColor"), lineSpacing: 1)

    static let bodyBold_nunito = FontTemplate(font: Font.custom("Nunito-Bold", size: 14), weight: .bold, foregroundColor: .primary, lineSpacing: 0)
    static let bodySemibold_nunito = FontTemplate(font: Font.custom("Nunito-SemiBold", size: 14), weight: .semibold, foregroundColor: .primary, lineSpacing: 0)
    static let bodySemibold_nunito_secondary = FontTemplate(font: Font.custom("Nunito-SemiBold", size: 14), weight: .semibold, foregroundColor: .secondary, lineSpacing: 0)

    static let body_secondary_semibold = FontTemplate(font: Font.custom("Poppins-SemiBold", size: 14), weight: .semibold, foregroundColor: .secondary, lineSpacing: 1)
    static let body_secondary_medium = FontTemplate(font: Font.custom("Poppins-Medium", size: 14), weight: .medium, foregroundColor: .secondary, lineSpacing: 1)
    static let body_secondary = FontTemplate(font: Font.custom("Poppins-Regular", size: 14), weight: .regular, foregroundColor: .secondary, lineSpacing: 1)

    static let bodyMono = FontTemplate(font: Font.custom("LabMono-Regular", size: 14), weight: .regular, foregroundColor: .primary, lineSpacing: 1)
    static let body_Mono_secondary = FontTemplate(font: Font.custom("LabMono-Regular", size: 14), weight: .regular, foregroundColor: .secondary, lineSpacing: 1)

    static let caption = FontTemplate(font: Font.system(size: 12.0), weight: .regular, foregroundColor: .secondary, lineSpacing: 1)
    static let caption_semibold = FontTemplate(font: Font.system(size: 12.0), weight: .semibold, foregroundColor: .secondary, lineSpacing: 1)
    static let captionPrimary = FontTemplate(font: Font.system(size: 12.0), weight: .regular, foregroundColor: .primary, lineSpacing: 1)
    static let captionPrimary_semibold = FontTemplate(font: Font.system(size: 12.0), weight: .semibold, foregroundColor: .primary, lineSpacing: 1)
    static let captionError = FontTemplate(font: Font.system(size: 12.0), weight: .regular, foregroundColor: .red, lineSpacing: 1)

    static let caption_Mono_secondary = FontTemplate(font: Font.custom("LabMono-Regular", size: 12), weight: .regular, foregroundColor: .secondary, lineSpacing: 1)

    static let alertMessage = FontTemplate(font: Font.system(size: 12.0), weight: .semibold, foregroundColor: .primary, lineSpacing: 0)

    static let monospace = FontTemplate(font: Font.system(.caption, design: .monospaced), weight: .regular, foregroundColor: .primary, lineSpacing: 0)
    static let monospaceBody = FontTemplate(font: Font.system(size: 14.0, design: .monospaced), weight: .semibold, foregroundColor: .primary, lineSpacing: 0)
    static let monospaceBold = FontTemplate(font: Font.system(.caption, design: .monospaced), weight: .bold, foregroundColor: .primary, lineSpacing: 0)
    static let monospaceSemibold = FontTemplate(font: Font.system(.caption, design: .monospaced), weight: .semibold, foregroundColor: .primary, lineSpacing: 0)

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
        return Color(NSColor(red: 0.82, green: 0.82, blue: 0.84, alpha: 1.0))
        #elseif os(iOS)
        return Color(.systemGray4)
        #endif
    }()

    static var disabledGray: Color = {
        #if targetEnvironment(macCatalyst)
        return Color(NSColor.systemGray3)
        #elseif os(macOS)
        return Color(NSColor(red: 0.82, green: 0.82, blue: 0.84, alpha: 1.0))
        #elseif os(iOS)
        return Color(.systemGray3)
        #endif
    }()

}
