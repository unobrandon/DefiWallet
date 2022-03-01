//
//  CheckmarkView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/28/22.
//

import SwiftUI

struct CheckmarkView: View {

    @State private var checkmark = false
    @State private var circle = false

    private let size: CGFloat

    init(size: CGFloat) {
        self.size = size
    }

    var body: some View {
            ZStack(alignment: .center) {
                Circle()
                    .trim(from: 0, to: circle ? 0.85 : 0)
                    .stroke(Color.primary, style: StrokeStyle(lineWidth: size >= 22 ? 2 : size >= 18 ? 1.5 : 1.2, lineCap: .round))
                    .rotationEffect(.init(degrees: -10))
                    .frame(width: size, height: size)
                    .shadow(color: Color.black.opacity(0.15), radius: 4, x: 0, y: 0)

                GeometryReader { geometry in
                    Path { path in
                        let width: CGFloat = min(geometry.size.width, geometry.size.height)
                        let height = geometry.size.height

                        path.addLines([
                            .init(x: width/2 - (size * 0.2), y: height/2 - (size * 0.2)),
                            .init(x: width/2, y: height/2),
                            .init(x: width/2 + (size * 0.55), y: height/2 - (size * 0.55))
                        ])
                    }
                    .trim(from: 0, to: checkmark ? 1 : 0)
                    .stroke(style: StrokeStyle(lineWidth: size >= 45 ? 5 : size >= 30 ? 3 : size >= 25 ? 2.5 : 2, lineCap: .round))
                    .frame(width: size * 0.6, height: size * 0.6)
                    .aspectRatio(1, contentMode: .fit)
                    .offset(y: size * 0.1)
                }
            }.frame(width: size, height: size)
            .onAppear {
                withAnimation(Animation.easeOut(duration: 0.7)) {
                    self.checkmark.toggle()
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    withAnimation(Animation.easeInOut(duration: 0.45)) {
                        self.circle.toggle()
                    }
                }
            }
    }

}
