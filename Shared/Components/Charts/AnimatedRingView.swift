//
//  AnimatedRingView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 4/5/22.
//

import SwiftUI

struct AnimatedRingView: View {

    var ring: RingProgressModel
    var index: Int
    let lineWidth: Double
    @State var showRing: Bool = false

    var body: some View {
        ZStack {
            Circle().stroke(ring.keyColor.opacity(0.25), lineWidth: lineWidth + 2)

            Circle()
                .trim(from: 0, to: showRing ? ring.progress : 0)
                .stroke(ring.keyColor, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
                .rotationEffect(.init(degrees: -90))
        }
        .padding(CGFloat(index) * 12)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                withAnimation(.interactiveSpring(response: 1.0,
                                                 dampingFraction: 0.8,
                                                 blendDuration: 1).delay(Double(index) * 0.25)) {
                    showRing = true
                }
            }
        }
    }
}
