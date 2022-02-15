//
//  IrregularGradient.swift
//  ChatrUI
//
//  Created by Brandon Shaw on 1/24/22.
//

import SwiftUI

public struct IrregularGradient<Background: View>: View {

    var colors: [Color]
    var background: Background
    var speed: Double
    var shouldAnimate: Binding<Bool>

    public init(colors: [Color],
                background: @autoclosure @escaping () -> Background,
                speed: Double = 10,
                shouldAnimate: Binding<Bool> = .constant(true)) {

        self.colors = colors
        self.background = background()
        self.shouldAnimate = shouldAnimate
        self.speed = speed

    }

    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                background
                ZStack {
                    ForEach(0..<colors.count) { index in
                        Blob(color: colors[index], animate: shouldAnimate.wrappedValue, speed: speed, geometry: geometry)
                    }
                }
                .blur(radius: pow(min(geometry.size.width, geometry.size.height), 0.75))
            }
            .clipped()
        }
    }

}

public extension IrregularGradient where Background == Color {

    init(colors: [Color], backgroundColor: Color = .clear, speed: Double = 10, shouldAnimate: Binding<Bool> = .constant(true)) {
        self.colors = colors
        self.background = backgroundColor
        self.shouldAnimate = shouldAnimate
        self.speed = speed
    }

}
