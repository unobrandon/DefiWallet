//
//  View+Extensions.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/14/22.
//

import SwiftUI

extension View {

    public func fontTemplate(_ template: FontTemplating) -> some View {
        modifier(FontTemplateModifier(template: template))
    }

    public func irregularGradient<Background: View>(colors: [Color], background: @autoclosure @escaping () -> Background, shouldAnimate: Binding<Bool> = .constant(true), speed: Double = 10) -> some View {
        self
            .overlay(IrregularGradient(colors: colors, background: background(), speed: speed, shouldAnimate: shouldAnimate))
            .mask(self)
    }

    public func irregularGradient(colors: [Color], backgroundColor: Color = .clear, shouldAnimate: Binding<Bool> = .constant(true), speed: Double = 10) -> some View {
        self
            .overlay(IrregularGradient(colors: colors, backgroundColor: backgroundColor, speed: speed, shouldAnimate: shouldAnimate))
            .mask(self)
    }

}
