//
//  ClickInteractiveStyle.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/13/22.
//

import SwiftUI

struct ClickInteractiveStyle: ButtonStyle {

    func makeBody(configuration: ClickInteractiveStyle.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.99 : 1.0)
    }

}
