//
//  AlertBanner.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 3/3/22.
//

import SwiftUI

struct AlertBanner: View {

    private let message: String
    private let color: Color

    init(message: String, color: Color) {
        self.message = message
        self.color = color
    }

    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            Image(systemName: "exclamationmark.triangle")
                .resizable()
                .frame(width: 18, height: 18, alignment: .center)
                .font(Font.title.weight(.semibold))
                .foregroundColor(color)

            Text(message)
                .fontTemplate(DefaultTemplate.alertMessage)
                .padding(.horizontal)
        }
        .padding(10)
        .background(RoundedRectangle(cornerRadius: 5, style: .circular).stroke(color, lineWidth: 1.5).background(color.opacity(0.3)))
        .frame(maxWidth: Constants.iPadMaxWidth)
    }

}
