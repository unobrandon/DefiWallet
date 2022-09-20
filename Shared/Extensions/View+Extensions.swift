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

    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(GeometryReader { geometryProxy in
          Color.clear.preference(key: SizePreferenceKey.self, value: geometryProxy.size)
        })
        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }

    func showTabBar() -> some View {
        return self.modifier(ShowTabBar())
    }

    func hiddenTabBar() -> some View {
        return self.modifier(HiddenTabBar())
    }

    func navigationBarTitle<Content>(@ViewBuilder content: () -> Content) -> some View where Content : View {
        self.toolbar {
            ToolbarItem(placement: .principal, content: content)
        }
    }

    func measureSize(perform action: @escaping (CGSize) -> Void) -> some View {
        self.modifier(MeasureSizeModifier())
            .onPreferenceChange(SizePreferenceKey.self, perform: action)
    }

    func animationObserver<Value: VectorArithmetic>(for value: Value, onChange: ((Value) -> Void)? = nil,
                                                    onComplete: (() -> Void)? = nil) -> some View {
        self.modifier(AnimationObserverModifier(for: value, onChange: onChange, onComplete: onComplete))
    }

    func marquee(duration: TimeInterval, direction: Marquee.Direction = .rightToLeft,
                 autoreverse: Bool = false) -> some View {
        self.modifier(Marquee(duration: duration, direction: direction, autoreverse: autoreverse))
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

struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero

    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

struct MeasureSizeModifier: ViewModifier {
    func body(content: Content) -> some View {
        content.background(GeometryReader { geometry in
            Color.clear.preference(key: SizePreferenceKey.self,
                                   value: geometry.size)
        })
    }
}

public struct AnimationObserverModifier<Value: VectorArithmetic>: AnimatableModifier {

    private let observedValue: Value
    private let onChange: ((Value) -> Void)?
    private let onComplete: (() -> Void)?

    public var animatableData: Value {
        didSet {
            notifyProgress()
        }
    }

    public init(for observedValue: Value,
                onChange: ((Value) -> Void)?,
                onComplete: (() -> Void)?) {
        self.observedValue = observedValue
        self.onChange = onChange
        self.onComplete = onComplete
        animatableData = observedValue
    }

    public func body(content: Content) -> some View {
        content
    }

    private func notifyProgress() {
        DispatchQueue.main.async {
            onChange?(animatableData)
            if animatableData == observedValue {
                onComplete?()
            }
        }
    }

}
