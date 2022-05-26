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
        HStack(alignment: .center, spacing: 15) {
            Image(systemName: "exclamationmark.triangle")
                .resizable()
                .frame(width: 18, height: 18, alignment: .center)
                .font(Font.title.weight(.semibold))
                .foregroundColor(color)
                .padding(.leading, 15)

            Text(message)
                .fontTemplate(DefaultTemplate.alertMessage)
                .padding(.trailing, 5)

            Spacer()
        }
        .frame(maxWidth: Constants.iPadMaxWidth)
        .padding(.vertical, 10)
        .background(RoundedRectangle(cornerRadius: 10, style: .circular).stroke(color, lineWidth: 1).background(color.opacity(0.15)))
        .padding(.horizontal, 2)
        .padding(.horizontal)
    }

}
