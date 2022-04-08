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
        ZStack(alignment: .center) {
            Button(action: {
                self.actionTap()
            }, label: {
                VStack(alignment: .leading, spacing: 0) {
                    HStack(alignment: .top, spacing: 5) {
                        Text("\(index + 1)")
                            .fontTemplate(DefaultTemplate.caption_semibold)

                        Text(data.name ?? "").fontTemplate(DefaultTemplate.gasPriceFont)

                        Spacer()
                        VStack(alignment: .trailing, spacing: 0) {
                            HStack(alignment: .center, spacing: 10) {
                                HStack(alignment: .center, spacing: 1) {
                                    if let num = Double("".forTrailingZero(temp: data.marketCap?.truncate(places: 2) ?? 0.00)) {
                                        Text("$").fontTemplate(DefaultTemplate.bodyBold)

                                        MovingNumbersView(number: num,
                                                          numberOfDecimalPlaces: 2,
                                                          fixedWidth: nil,
                                                          showComma: true) { str in
                                            Text(str).fontTemplate(DefaultTemplate.bodyMedium)
                                        }
                                    }
                                }.mask(AppGradients.movingNumbersMask)

                                Image(systemName: "chevron.right")
                                    .resizable()
                                    .font(Font.title.weight(.bold))
                                    .scaledToFit()
                                    .frame(width: 7, height: 12, alignment: .center)
                                    .foregroundColor(.secondary)
                            }

                            ProminentRoundedLabel(text: (data.marketCapChange24H ?? 0 >= 0 ? "+" : "") +
                                                  "\("".forTrailingZero(temp: data.marketCapChange24H?.truncate(places: 2) ?? 0.00))%",
                                                  color: data.marketCapChange24H ?? 0 >= 0 ? .green : .red,
                                                  style: service.themeStyle)
                                .padding(.trailing, 12)
                        }
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal)

                    HStack(alignment: .center, spacing: 5) {
                        HStack(alignment: .center, spacing: -10) {
                            if let top3_Coins = data.top3_Coins {
                                ForEach(top3_Coins, id: \.self) { image in
                                    RemoteImage(image, size: 22)
                                        .clipShape(Circle())
                                        .overlay(Circle().strokeBorder(DefaultTemplate.borderColor.opacity(1.0), lineWidth: 1))
                                        .shadow(color: Color.black.opacity(service.themeStyle == .shadow ? 0.15 : 0.0), radius: 8, x: 0, y: 6)
                                }
                            }
                        }

                        HStack(alignment: .center, spacing: 1) {
                            if let num = Double("".forTrailingZero(temp: data.volume24H?.truncate(places: 2) ?? 0.00)) {
                                Text("$").fontTemplate(DefaultTemplate.body_secondary)

                                MovingNumbersView(number: num,
                                                  numberOfDecimalPlaces: 2,
                                                  fixedWidth: nil,
                                                  showComma: true) { str in
                                    Text(str).fontTemplate(DefaultTemplate.body_secondary)
                                }
                            }
                        }.mask(AppGradients.movingNumbersMask)

                        Spacer()
                    }
                    .padding(.horizontal)

                    Text(data.content ?? "")
                        .fontTemplate(DefaultTemplate.caption)
                        .lineLimit(3)
                        .padding()
                }
                .contentShape(Rectangle())
            })
            .buttonStyle(DefaultInteractiveStyle(style: self.style))
            .frame(minWidth: 100, maxWidth: .infinity)

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
