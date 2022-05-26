//
//  View+Extensions.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/14/22.
//

import SwiftUI
import UIKit

extension View {

    func fontTemplate(_ template: FontTemplating) -> some View {
        modifier(FontTemplateModifier(template: template))
    }

    func irregularGradient<Background: View>(colors: [Color],
                                             background: @autoclosure @escaping () -> Background,
                                             shouldAnimate: Binding<Bool> = .constant(true),
                                             speed: Double = 10) -> some View { self
            .overlay(IrregularGradient(colors: colors, background: background(), speed: speed, shouldAnimate: shouldAnimate))
            .mask(self)
    }

    func irregularGradient(colors: [Color], backgroundColor: Color = .clear, shouldAnimate: Binding<Bool> = .constant(true), speed: Double = 10) -> some View { self
            .overlay(IrregularGradient(colors: colors, backgroundColor: backgroundColor, speed: speed, shouldAnimate: shouldAnimate))
            .mask(self)
    }

    func showTabBar() -> some View {
        return self.modifier(ShowTabBar())
    }

    func hiddenTabBar() -> some View {
        return self.modifier(HiddenTabBar())
    }

}

extension UIView {

    func allSubviews() -> [UIView] {
        var res = self.subviews

        for subview in self.subviews {
            let riz = subview.allSubviews()
            res.append(contentsOf: riz)
        }

        return res
    }

}

struct Tool {

    static func showTabBar() {
        UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.allSubviews().forEach({ view in
            if let view = view as? UITabBar {
                view.isHidden = false
            }
        })
    }

    static func hiddenTabBar() {
        UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.allSubviews().forEach({ view in
            if let view = view as? UITabBar {
                view.isHidden = true
            }
        })
    }

}

struct ShowTabBar: ViewModifier {

    func body(content: Content) -> some View {
        return content.padding(.zero).onAppear {
            Tool.showTabBar()
        }
    }

}

struct HiddenTabBar: ViewModifier {

    func body(content: Content) -> some View {
        return content.padding(.zero).onAppear {
            Tool.hiddenTabBar()
        }
    }

}
