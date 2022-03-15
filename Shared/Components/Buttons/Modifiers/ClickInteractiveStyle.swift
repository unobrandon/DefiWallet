//
//  ClickInteractiveStyle.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/13/22.
//

import SwiftUI

struct ClickInteractiveStyle: ButtonStyle {

    private var impact: Double

    init(_ impactAmount: Double) {
        self.impact = impactAmount
    }

    func makeBody(configuration: ClickInteractiveStyle.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? impact : 1.0)
    }

}
