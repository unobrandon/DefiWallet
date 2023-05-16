//
//  TransactionListCell.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 6/14/22.
//

import SwiftUI

struct TransactionListCell: View {

    @ObservedObject private var service: AuthenticatedServices

    private let data: TransactionResult
    private var isLast: Bool
    private let style: AppStyle
    private let action: () -> Void
    private let numberFormatter = NumberFormatter()

    init(service: AuthenticatedServices, data: TransactionResult, isLast: Bool, style: AppStyle, action: @escaping () -> Void) {
        self.service = service
        self.data = data
        self.isLast = isLast
        self.style = style
        self.action = action
        self.numberFormatter.numberStyle = NumberFormatter.Style.decimal
    }

    var body: some View {
        ZStack(alignment: .center) {
            Button(action: {
                self.actionTap()
            }, label: {
                VStack(alignment: .trailing, spacing: 0) {
                    HStack(alignment: .center, spacing: 10) {
                        if let direction = data.direction {
                            ZStack {
                                if let image = data.imageSmall ?? data.imageLarge {
                                    RemoteImage(image, size: 44)
                                        .clipShape(Circle())
                                        .overlay(Circle().strokeBorder(DefaultTemplate.borderColor.opacity(0.8), lineWidth: 1))
                                        .shadow(color: Color.black.opacity(service.themeStyle == .shadow ? 0.15 : 0.0), radius: 8, x: 0, y: 6)
                                } else {
                                    StandardSystemImage(service.wallet.transactionDirectionImage(direction), color: service.wallet.transactionDirectionColor(direction), size: 44, cornerRadius: 24, style: style)
                                        .padding(.horizontal, 10)
                                }

                                if let network = data.network, data.type == .token {
                                    service.wallet.getNetworkTransactImage(network)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 18, height: 18, alignment: .center)
                                        .clipShape(Circle())
                                        .overlay(Circle().foregroundColor(.clear).overlay(Circle().stroke(Color("baseBackground_bordered"), lineWidth: 2.5)))
                                        .offset(x: -16, y: 16)
                                }
                            }
                        }

                        VStack(alignment: .leading, spacing: 0) {
                            // Upper details
                            HStack(alignment: .center, spacing: 5) {
                                if let title = data.direction?.rawValue {
                                    Text(title.capitalized)
                                        .fontTemplate(DefaultTemplate.subheadingMedium)
                                }

                                Spacer()
//                                if let timestamp = data.timestamp {
//                                    Text(timestamp.getElapsedInterval())
//                                        .fontTemplate(DefaultTemplate.caption)
//                                }

                                Image(systemName: "chevron.right")
                                    .resizable()
                                    .font(Font.title.weight(.semibold))
                                    .scaledToFit()
                                    .frame(width: 6, height: 12, alignment: .center)
                                    .foregroundColor(.secondary)
                            }

                            // Lower details
                            HStack(alignment: .center, spacing: 5) {
//                                let finalNumber = numberFormatter.number(from: "\(data.value ?? 0.00)")
//
//                                Text((data.direction == .sent ? "-" : "") + "\(Double(truncating: finalNumber ?? 0.00))")
//                                    .fontTemplate(FontTemplate(font: Font.system(size: 14.0), weight: .medium, foregroundColor: service.wallet.transactionDirectionColor(data.direction ?? .swap), lineSpacing: 0))
//                                    .lineLimit(1)

                                if let name = data.symbol ?? data.name {
                                    Text(name.lowercased())
                                        .fontTemplate(DefaultTemplate.caption)
                                }

                                Spacer()
                                if data.receiptStatus == "0" {
                                    Text("FAILED")
                                        .fontTemplate(FontTemplate(font: Font.system(size: 12.0), weight: .bold, foregroundColor: style == .shadow ? .white : .red, lineSpacing: 0))
                                        .background(RoundedRectangle(cornerRadius: 4, style: .circular).foregroundColor(Color.red.opacity(style == .shadow ? 1.0 : 0.15)).frame(width: 56, height: 20))
                                        .padding(.trailing, 5)
                                } else if data.direction == .received, let fromAddress = data.fromAddress {
                                    Text("from: " + "\(fromAddress.formatAddress())")
                                        .fontTemplate(DefaultTemplate.captionPrimary)
                                } else if data.direction == .sent, let toAddress = data.toAddress {
                                    Text("to: " + "\(toAddress.formatAddress())")
                                        .fontTemplate(DefaultTemplate.captionPrimary)
                                } else if data.direction == .swap, let gasFee = data.gasPrice {
                                    Text("gas: \(gasFee)")
                                        .fontTemplate(DefaultTemplate.captionPrimary)
                                }
                            }
                        }
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal)

                    if style == .shadow, !isLast {
                        Divider().padding(.leading, 65)
                    } else if style == .border, !isLast {
                        Rectangle().foregroundColor(DefaultTemplate.borderColor)
                            .frame(height: 1)
                    }
                }
                .contentShape(Rectangle())
            })
            .buttonStyle(DefaultInteractiveStyle(style: self.style))
            .frame(minWidth: 100, maxWidth: .infinity)

        }
    }

    private func actionTap() {
        #if os(iOS)
            HapticFeedback.rigidHapticFeedback()
        #endif

        action()
    }
}
