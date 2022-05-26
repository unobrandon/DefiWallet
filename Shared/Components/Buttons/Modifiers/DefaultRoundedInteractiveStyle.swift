//
//  DefaultRoundedInteractiveStyle.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 3/4/22.
//

import SwiftUI

struct DefaultRoundedInteractiveStyle: ButtonStyle {

    @Binding var isDisabled: Bool

    func makeBody(configuration: DefaultRoundedInteractiveStyle.Configuration) -> some View {
        configuration.label
            .scaleEffect(!isDisabled && configuration.isPressed ? 0.99 : 1.0)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 15, style: .circular)
                    .foregroundColor(isDisabled ? Color("disabledGray") : Color("AccentColor")))
            .frame(maxWidth: 380, minHeight: 49)
            .disabled(isDisabled)
    }

}
