//
//  MarqueeScrollView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 6/8/22.
//

import SwiftUI

struct Marquee: ViewModifier {

    let duration: TimeInterval
    let direction: Direction
    let autoreverse: Bool

    @State private var offset = CGFloat.zero
    @State private var parentSize = CGSize.zero
    @State private var contentSize = CGSize.zero

    func body(content: Content) -> some View {

        Color.clear
            .frame(height: 0)
            .measureSize { size in
                parentSize = size
                updateAnimation(sizeChanged: true)
            }

        content
            .measureSize { size in
                contentSize = size
                updateAnimation(sizeChanged: true)
            }
            .offset(x: offset)
            .animationObserver(for: offset, onComplete: {
                updateAnimation(sizeChanged: false)
            })
    }

    private func updateAnimation(sizeChanged: Bool) {
        if sizeChanged || !autoreverse {
            offset = max(parentSize.width, contentSize.width) * ((direction == .leftToRight) ? -1 : 1)
        }

        withAnimation(.linear(duration: duration)) {
            offset = -offset
        }
    }

    enum Direction {
        case leftToRight, rightToLeft
    }

}
