//
//  HistoryListCell.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 3/21/22.
//

import SwiftUI

struct HistoryListCell: View {

    @ObservedObject private var service: AuthenticatedServices

    private let data: HistoryData
    private var isLast: Bool
    private let style: AppStyle
    private let action: () -> Void

    init(service: AuthenticatedServices, data: HistoryData, isLast: Bool, style: AppStyle, action: @escaping () -> Void) {
        self.service = service
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
                VStack(alignment: .trailing, spacing: 0) {
                    HStack(alignment: .center) {
                        ZStack {
                            StandardSystemImage(service.wallet.transactionImage(data.direction), color: service.wallet.transactionColor(data.direction), size: 44, cornerRadius: 22, style: style)
                                .padding(.horizontal, 10)

                            service.wallet.getNetworkImage(data.network)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 18, height: 18, alignment: .center)
                                .clipShape(Circle())
                                .overlay(Circle().foregroundColor(.clear).overlay(Circle().stroke(Color("baseBackground_bordered"), lineWidth: 2.5)))
                                .offset(x: -15, y: 15)
                        }

                        VStack(alignment: .leading, spacing: 2.5) {
                            Text(data.direction == .incoming ? "Received" : data.direction == .outgoing ? "Sent" : "Exchanged")
                                .fontTemplate(DefaultTemplate.subheadingSemiBold)

                            Text((data.direction == .outgoing ? "-" : "") + "\("".forTrailingZero(temp: Double(data.amount)?.truncate(places: 4) ?? 0.00)) \(data.symbol.prefix(6))")
                                .fontTemplate(FontTemplate(font: Font.system(size: 14.0), weight: .medium, foregroundColor: service.wallet.transactionColor(data.direction), lineSpacing: 0))
                        }

                        Spacer()
                        VStack(alignment: .trailing, spacing: 2.5) {
                            HStack(alignment: .center) {
                                Text("\(data.timeStamp.getFullElapsedInterval())").fontTemplate(DefaultTemplate.caption)

                                Image(systemName: "chevron.right")
                                    .resizable()
                                    .font(Font.title.weight(.semibold))
                                    .scaledToFit()
                                    .frame(width: 5, height: 10, alignment: .center)
                                    .foregroundColor(.secondary)
                            }

                            if data.direction == .incoming, let fromAddress = data.fromEns == nil ? data.from : data.fromEns {
                                Text("from: " + "\("".formatAddress(fromAddress))")
                                    .fontTemplate(DefaultTemplate.captionPrimary)
                            } else if data.direction == .outgoing, let toAddress = data.destination {
                                Text("to: " + "\("".formatAddress(toAddress))")
                                    .fontTemplate(DefaultTemplate.captionPrimary)
                            } else if data.direction == .exchange, let gasFee = data.gasPrice {
                                Text("gas fee: \(gasFee)")
                                    .fontTemplate(DefaultTemplate.captionPrimary)
                            }
                        }
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal)

                    if style == .shadow, !isLast {
                        Divider().padding(.leading, 40)
                    } else if style == .border, !isLast {
                        Rectangle().foregroundColor(DefaultTemplate.borderColor)
                            .frame(height: 1)
                    }
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
