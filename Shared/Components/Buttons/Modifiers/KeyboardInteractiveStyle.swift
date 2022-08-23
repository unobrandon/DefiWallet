//
//  KeyboardInteractiveStyle.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 8/22/22.
//

import SwiftUI

struct KeyboardInteractiveStyle: ButtonStyle {

    private let cornerRadius: CGFloat?

    init(cornerRadius: CGFloat? = 0) {
        self.cornerRadius = cornerRadius ?? 0
    }

    func makeBody(configuration: DefaultInteractiveStyle.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .background(getColor(configuration.isPressed).cornerRadius(cornerRadius ?? 0))
    }

    private func getColor(_ pressed: Bool) -> Color {
        return pressed ? Color("baseButton_selected") : Color.clear
    }

}
