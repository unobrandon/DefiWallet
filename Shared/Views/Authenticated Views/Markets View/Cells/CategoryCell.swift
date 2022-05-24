//
//  CategoryCell.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 4/8/22.
//

import SwiftUI

struct CategoryCell: View {

    @ObservedObject private var service: AuthenticatedServices

    private let data: TokenCategory
    private let index: Int
    private var isLast: Bool
    private let style: AppStyle
    private let action: () -> Void

    init(service: AuthenticatedServices, data: TokenCategory, index: Int, isLast: Bool, style: AppStyle, action: @escaping () -> Void) {
        self.service = service
        self.index = index
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
                HStack(alignment: .top, spacing: 0) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text(data.name ?? "").fontTemplate(DefaultTemplate.gasPriceFont)

                        HStack(alignment: .center, spacing: 5) {
                            ProminentRoundedLabel(text: (data.marketCapChange24H ?? 0 >= 0 ? "+" : "") +
                                                  "\("".forTrailingZero(temp: data.marketCapChange24H?.truncate(places: 2) ?? 0.00))%",
                                                  color: data.marketCapChange24H ?? 0 >= 0 ? .green : .red,
                                                  style: service.themeStyle)

                            if let num = Int(data.marketCap ?? 0), num != 0 {
                                Text("\(Locale.current.currencySymbol ?? "")\("".formatLargeNumber(num, size: .large))")
                                    .fontTemplate(DefaultTemplate.bodyMedium_secondary)
                            }
                        }

                        if let description = data.description, !description.isEmpty {
                            Text(description)
                                .fontTemplate(DefaultTemplate.caption)
                                .lineLimit(2)
                        }
                    }

                    Spacer()
                    HStack(alignment: .center, spacing: 0) {
                        HStack(alignment: .center, spacing: -8) {
                            if let top3_Coins = data.top3_Coins?.prefix(3) {
                                ForEach(top3_Coins.indices, id: \.self) { index in
                                    RemoteImage(top3_Coins[index], size: 22)
                                        .clipShape(Circle())
                                        .overlay(Circle().strokeBorder(DefaultTemplate.borderColor.opacity(1.0), lineWidth: 1))
                                        .shadow(color: Color.black.opacity(service.themeStyle == .shadow ? 0.15 : 0.0), radius: 8, x: 0, y: 6)
                                        .zIndex(index == 0 ? 3 : index == 1 ? 2 : 1)
                                }
                            }
                        }
                        .padding(.trailing, 10)

                        Image(systemName: "chevron.right")
                            .resizable()
                            .font(Font.title.weight(.bold))
                            .scaledToFit()
                            .frame(width: 7, height: 12, alignment: .center)
                            .foregroundColor(.secondary)
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
