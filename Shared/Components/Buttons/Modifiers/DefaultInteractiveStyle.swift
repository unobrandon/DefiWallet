//
//  DefaultInteractiveStyle.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/13/22.
//

import SwiftUI

struct DefaultInteractiveStyle: ButtonStyle {

    private var style: AppStyle
    private let cornerRadius: CGFloat?

    init(style: AppStyle, cornerRadius: CGFloat? = 0) {
        self.style = style
        self.cornerRadius = cornerRadius ?? 0
    }

    func makeBody(configuration: DefaultInteractiveStyle.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.99 : 1.0)
            .background(getColor(configuration.isPressed).cornerRadius(cornerRadius ?? 0))
    }

    private func getColor(_ pressed: Bool) -> Color {
        return pressed ? Color(style == .border ? "baseButton_selected_bordered" : "baseButton_selected") : Color("baseButton")
    }

}
