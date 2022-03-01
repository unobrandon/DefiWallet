//
//  LoadingView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/27/22.
//

import SwiftUI

struct LoadingIndicator: View {

    @State private var isLoading = false

    private let animation = Animation.linear(duration: 0.68)
        .repeatForever(autoreverses: false)
    private let size: CGFloat

    init(size: CGFloat) {
        self.size = size
    }

    var body: some View {
        Circle()
            .trim(from: 0, to: 0.75)
            .stroke(Color.primary, style: StrokeStyle(lineWidth: size >= 22 ? 2 : size >= 18 ? 1.5 : 1.2, lineCap: .round))
            .rotationEffect(.init(degrees: self.isLoading ? 360 : 0))
            .frame(width: size, height: size)
            .shadow(color: Color.black.opacity(0.15), radius: 4, x: 0, y: 0)
            .onAppear {
                withAnimation(animation, {
                    self.isLoading.toggle()
                })
            }
    }

}
