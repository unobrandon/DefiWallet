//
//  HistoryDetailView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 3/21/22.
//

import SwiftUI

struct HistoryDetailView: View {

    @EnvironmentObject private var walletRouter: WalletCoordinator.Router

    @ObservedObject private var service: AuthenticatedServices
    @ObservedObject private var store: WalletService

    private let data: TransactionResult
    private let numberFormatter = NumberFormatter()

    @State private var hasCopiedFromAddress: Bool = false
    @State private var hasCopiedToAddress: Bool = false
    @State private var hasCopiedBlockNumber: Bool = false

    init(data: TransactionResult, service: AuthenticatedServices) {
        self.service = service
        self.store = service.wallet
        self.data = data
    }

    var body: some View {
        BackgroundColorView(style: service.themeStyle, {
            ScrollView {
                VStack(alignment: .center, spacing: 5) {
                    ZStack {
                        StandardSystemImage(service.wallet.transactionDirectionImage(data.direction ?? .received),
                                            color: service.wallet.transactionDirectionColor(data.direction ?? .received),
                                            size: 64, cornerRadius: 32, style: service.themeStyle)

                        if data.type == .token, let network = data.network {
                            service.wallet.getNetworkTransactImage(network)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 24, height: 24, alignment: .center)
                                .clipShape(Circle())
                                .overlay(Circle().foregroundColor(.clear).overlay(Circle().stroke(Color("baseBackground_bordered"), lineWidth: 3.5)))
                                .offset(x: -22, y: 22)
                        }
                    }

                    let finalNumber = numberFormatter.number(from: "\(data.value ?? 0.00)")

                    Text((data.direction == .sent ? "-" : "") + "\(Double(truncating: finalNumber ?? 0.00))")
                        .fontTemplate(FontTemplate(font: Font.custom("Poppins-SemiBold", size: 36),
                                                   weight: .semibold,
                                                   foregroundColor: data.direction == .sent ? .red : data.direction == .sent ? .green : .blue, lineSpacing: 0))
                        .irregularGradient(colors: data.direction == .sent ? [Color("alertRed"), .orange] : data.direction == .received ? [Color("darkGreen"), .green] : [Color("accentColor"), .teal],
                                           background: data.direction == .sent ? Color("alertRed") : data.direction == .received ? Color.green : Color("AccentColor"))
                        .lineLimit(1)
                        .padding([.top, .horizontal])

                    Text(data.direction?.rawValue.capitalized ?? "").fontTemplate(DefaultTemplate.headingSemiBold)

                    if let timestamp = data.blockTimestamp {
                        Text(Date(timeIntervalSince1970: Double(timestamp / 1000)).mediumDateFormate())
                            .fontTemplate(DefaultTemplate.body_secondary)
                    }
                }
                .padding(.vertical, 40)

                ListSection(style: service.themeStyle) {
                    if let fromEthNameService = data.fromAddress {
                        ListInfoSmallButton(title: "From", info: fromEthNameService.formatAddressExtended(),
                                            subinfo: nil, actionSystemImage: "doc.on.doc",
                                            isLast: data.toAddress?.isEmpty ?? true, hasHaptic: false,
                                            style: service.themeStyle, action: {
                            UIPasteboard.general.string = fromEthNameService
                            HapticFeedback.successHapticFeedback()
                            showNotiHUD(image: "doc.on.doc", color: Color("AccentColor"), title: "Copied transaction's from address", subtitle: fromEthNameService.formatAddressExtended())
                            withAnimation {
                                hasCopiedFromAddress = true
                            }

                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                withAnimation {
                                    hasCopiedFromAddress = false
                                }
                            }
                        })
                        .disabled(hasCopiedFromAddress)
                    }

                    if let toEthNameService = data.toAddress {
                        ListInfoSmallButton(title: "To", info: toEthNameService.formatAddressExtended(), subinfo: nil, actionSystemImage: "doc.on.doc", isLast: true, hasHaptic: false, style: service.themeStyle, action: {
                            UIPasteboard.general.string = toEthNameService
                            HapticFeedback.successHapticFeedback()
                            showNotiHUD(image: "doc.on.doc", color: Color("AccentColor"), title: "Copied transaction's to address", subtitle: toEthNameService.formatAddressExtended())
                            withAnimation {
                                hasCopiedToAddress = true
                            }

                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                withAnimation {
                                    hasCopiedToAddress = false
                                }
                            }
                        })
                        .disabled(hasCopiedToAddress)
                    }
                }

                ListSection(title: "Details", style: service.themeStyle) {
                    if let block = data.blockNumber {
                        ListInfoSmallButton(title: "Block #", info: block, subinfo: nil, actionSystemImage: "doc.on.doc", isLast: false, hasHaptic: false, style: service.themeStyle, action: {
                            UIPasteboard.general.string = block
                            HapticFeedback.successHapticFeedback()
                            showNotiHUD(image: "doc.on.doc", color: Color("AccentColor"), title: "Copied transaction's block number", subtitle: block)
                            withAnimation {
                                hasCopiedBlockNumber = true
                            }

                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                withAnimation {
                                    hasCopiedBlockNumber = false
                                }
                            }
                        })
                        .disabled(hasCopiedBlockNumber)
                    }

                    if let hash = data.hash?.formatAddressExtended() {
                        ListInfoView(title: "Hash", info: hash, style: service.themeStyle, isLast: false)
                    }

                    ListInfoCustomView(title: "Status", style: service.themeStyle, isLast: false) {
                        BorderedButton(title: data.receiptStatus == "0" ? "FAILED" : "Successful",
                                       systemImage: data.receiptStatus == "0" ? "xmark.octagon.fill" : "checkmark.circle.fill",
                                       size: .mini, tint: data.receiptStatus == "0" ? Color.red : Color.green, action: {  })
                            .frame(height: 22)
                    }

                    if let network = data.network {
                        ListInfoView(title: "Network", info: network, style: service.themeStyle, isLast: false)
                    }

                    if let gasPrice = data.gasPrice {
                        ListInfoView(title: "Gas Price", info: gasPrice + " gwei", style: service.themeStyle, isLast: false)
                    }

                    if let gasFee = data.gas {
                        ListInfoView(title: "Gas Fee", info: gasFee + " gwei", style: service.themeStyle, isLast: false)
                    }

                    if let nonce = data.nonce {
                        ListInfoView(title: "Nonce", info: nonce, style: service.themeStyle, isLast: true)
                    }
                }

                ListSection(title: "More", style: service.themeStyle) {
                    ListStandardButton(title: "View on \(store.getBlockExplorerName(data.network ?? ""))", systemImage: "safari", isLast: false, style: service.themeStyle, action: {
                        walletRouter.route(to: \.safari, store.getScannerUrl(data.network ?? "") + (data.blockHash ?? ""))
                    })

                    ListStandardButton(title: "Share transaction", systemImage: "square.and.arrow.up", isLast: true, style: service.themeStyle, action: {
                        guard let shareUrl = URL(string: store.getScannerUrl(data.network ?? "") + (data.hash ?? "")) else {
                            #if os(iOS)
                                HapticFeedback.errorHapticFeedback()
                            #endif
                            return
                        }

                        store.shareSheet(url: shareUrl)
                    })
                }
                .padding(.bottom)
            }
        })
        .navigationBarTitle("Details", displayMode: .inline)
        .onAppear {
            DispatchQueue.main.async {
                Tool.hiddenTabBar()
            }
        }
    }

}
