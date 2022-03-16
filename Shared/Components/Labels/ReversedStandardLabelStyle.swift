//
//  ReversedStandardLabelStyle.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 3/15/22.
//

import SwiftUI

struct ReversedStandardLabelStyle: LabelStyle {

    let spacing: Double

    func makeBody(configuration: Configuration) -> some View {
        HStack(alignment: .center, spacing: spacing) {
            configuration.title
            configuration.icon
        }
    }

}

// MARK: Example:

// Label("more details", systemImage: "safari")
//     .labelStyle(ReversedStandardLabelStyle())
//     .font(.subheadline)
//     .foregroundColor(.blue)
