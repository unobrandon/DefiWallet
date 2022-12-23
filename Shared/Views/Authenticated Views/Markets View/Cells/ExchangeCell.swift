//
//  ExchangeCell.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 5/25/22.
//

import SwiftUI

struct ExchangeCell: View {

    @ObservedObject private var service: AuthenticatedServices

    private let data: ExchangeModel
    private var isLast: Bool
    private let style: AppStyle
    private let action: () -> Void

    init(service: AuthenticatedServices, data: ExchangeModel, isLast: Bool, style: AppStyle, action: @escaping () -> Void) {
        self.service = service
        self.data = data
        self.isLast = isLast
        self.style = style
        self.action = action
    }

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Button(action: {
                self.actionTap()
            }, label: {
                HStack(alignment: .center, spacing: 10) {
                    RemoteImage(data.image ?? "", size: 40)
                        .clipShape(Circle())
                        .overlay(Circle().strokeBorder(DefaultTemplate.borderColor.opacity(0.75), lineWidth: 1))
                        .shadow(color: Color.black.opacity(service.themeStyle == .shadow ? 0.15 : 0.0), radius: 8, x: 0, y: 6)

                    VStack(alignment: .leading, spacing: 0) {
                        Text(data.name ?? "").fontTemplate(DefaultTemplate.gasPriceFont)

                        if let description = data.description, !description.isEmpty {
                            Text(description)
                                .fontTemplate(DefaultTemplate.caption)
                                .lineLimit(2)
                        }
                    }

                    Spacer()
                    Image(systemName: "chevron.right")
                        .resizable()
                        .font(Font.title.weight(.bold))
                        .scaledToFit()
                        .frame(width: 7, height: 12, alignment: .center)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                .contentShape(Rectangle())
            })
            .buttonStyle(DefaultInteractiveStyle(style: self.style))
            .frame(minWidth: 100, maxWidth: .infinity)

            if style == .shadow, !isLast {
                Divider().padding(.leading, 20)
            } else if style == .border, !isLast {
                Rectangle().foregroundColor(DefaultTemplate.borderColor)
                    .frame(height: 1)
            }
        }
    }

    private func actionTap() {
        #if os(iOS)
            HapticFeedback.rigidHapticFeedback()
        #endif

        action()
    }

}
