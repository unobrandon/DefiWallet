//
//  CompanyCell.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 6/7/22.
//

import SwiftUI

struct CompanyCell: View {

    @ObservedObject private var service: AuthenticatedServices

    private let data: Company
    @State var coin: String
    private var isLast: Bool
    private let style: AppStyle
    private let action: () -> Void

    init(service: AuthenticatedServices, data: Company, coin: String, isLast: Bool, style: AppStyle, action: @escaping () -> Void) {
        self.service = service
        self.data = data
        self.coin = coin
        self.isLast = isLast
        self.style = style
        self.action = action
    }

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Button(action: {
                self.actionTap()
            }, label: {
                HStack(alignment: .center, spacing: 5) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text(data.name ?? "").fontTemplate(DefaultTemplate.gasPriceFont)

                        if let description = data.symbol, !description.isEmpty {
                            Text(description)
                                .fontTemplate(DefaultTemplate.caption)
                                .lineLimit(2)
                        }
                    }

                    Spacer()
                    VStack(alignment: .trailing, spacing: 0) {
                        HStack(alignment: .bottom, spacing: 5) {
                            Text("\("".formatLargeNumber(data.totalHoldings ?? 0, size: .small, scale: 2))").fontTemplate(DefaultTemplate.bodyBold)

                            Text(coin).fontTemplate(DefaultTemplate.caption)
                        }

                        Text("$\("".formatLargeNumber(data.totalCurrentValueUsd ?? 0, size: .large))")
                            .fontTemplate(DefaultTemplate.body)
                            .lineLimit(2)
                    }
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
        }.simultaneousGesture(TapGesture().onEnded {
            #if os(iOS)
                HapticFeedback.rigidHapticFeedback()
            #endif
        })
    }

    private func actionTap() {
        #if os(iOS)
            HapticFeedback.lightHapticFeedback()
        #endif

        action()
    }

}
