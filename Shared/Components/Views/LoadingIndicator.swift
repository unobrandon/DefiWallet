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
    private let color: Color?
    private let strokeWidth: CGFloat?

    init(size: CGFloat, color: Color? = .primary, strokeWidth: CGFloat? = nil) {
        self.size = size
        self.color = color
        self.strokeWidth = strokeWidth
    }

    var body: some View {
        Rectangle()
            .frame(width: size, height: size, alignment: .center)
            .foregroundColor(.clear)
            .overlay(
                Circle()
                    .trim(from: 0, to: 0.75)
                    .stroke(color ?? .primary, style: StrokeStyle(lineWidth: strokeWidth != nil ? strokeWidth ?? 2 : size >= 22 ? 2 : size >= 18 ? 1.5 : 1.2, lineCap: .round))
                    .padding(2.5)
                    .rotationEffect(.init(degrees: self.isLoading ? 360 : 0))
                    .shadow(color: Color.black.opacity(0.15), radius: 4, x: 0, y: 0)
            )
            .onAppear {
                withAnimation(animation, {
                    self.isLoading.toggle()
                })
            }
    }

}
