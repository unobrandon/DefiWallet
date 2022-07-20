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

                        service.wallet.getNetworkTransactImage(data.network ?? "")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 24, height: 24, alignment: .center)
                            .clipShape(Circle())
                            .overlay(Circle().foregroundColor(.clear).overlay(Circle().stroke(Color("baseBackground_bordered"), lineWidth: 3.5)))
                            .offset(x: -22, y: 22)
                    }

                    Text(data.direction?.rawValue.capitalized ?? "").fontTemplate(DefaultTemplate.headingSemiBold)
                        .padding(.top, 30)

                    Text((data.direction == .sent ? "-" : "") + "\("".forTrailingZero(temp: data.value?.truncate(places: 8) ?? 0.00))")
                        .fontTemplate(FontTemplate(font: Font.custom("Poppins-SemiBold", size: 36),
                                                   weight: .semibold,
                                                   foregroundColor: data.direction == .sent ? .red : data.direction == .sent ? .green : .blue, lineSpacing: 0))
                        .irregularGradient(colors: data.direction == .sent ? [Color("alertRed"), .orange] : data.direction == .received ? [Color("darkGreen"), .green] : [Color("accentColor"), .teal],
                                           background: data.direction == .sent ? Color("alertRed") : data.direction == .received ? Color.green : Color("AccentColor"))

                    Text(Date(timeIntervalSince1970: Double(data.blockTimestamp ?? 0 / 1000)).mediumDateFormate())
                        .fontTemplate(DefaultTemplate.body_secondary)
                }
                .padding(.vertical, 40)

                ListSection(style: service.themeStyle) {
                    if let fromEthNameService = data.fromAddress {
                        ListInfoView(title: "From", info: fromEthNameService.formatAddressExtended(), style: service.themeStyle, isLast: false)
                    }

                    if let toEthNameService = data.toAddress {
                        ListInfoView(title: "To", info: toEthNameService.formatAddressExtended(), style: service.themeStyle, isLast: true)
                    }
                }

                ListSection(title: "Details", style: service.themeStyle) {
                    ListInfoView(title: "Hash", info: data.hash?.formatAddressExtended() ?? "", style: service.themeStyle, isLast: false)

                    ListInfoCustomView(title: "Status", style: service.themeStyle, isLast: false) {
                        BorderedButton(title: data.receiptStatus == "1" ? "Successful" : "FAILED",
                                       systemImage: data.receiptStatus == "1" ? "checkmark.circle.fill" : "xmark.octagon.fill",
                                       size: .mini, tint: data.receiptStatus == "1" ? Color.green : Color.red, action: {  })
                            .frame(height: 22)
                    }

                    ListInfoView(title: "Network", info: data.network ?? "", style: service.themeStyle, isLast: false)

                    ListInfoView(title: "Gas Price", info: (data.gasPrice ?? "") + " gwei", style: service.themeStyle, isLast: false)

                    ListInfoView(title: "Gas Fee", info: (data.gas ?? "") + " gwei", style: service.themeStyle, isLast: false)

                    ListInfoView(title: "Block", info: data.blockNumber ?? "", style: service.themeStyle, isLast: false)

                    if let nonce = data.nonce {
                        ListInfoView(title: "Nonce", info: nonce, style: service.themeStyle, isLast: true)
                    }
                }

                ListSection(title: "More", style: service.themeStyle) {
                    ListStandardButton(title: "View on \(store.getBlockExplorerName(data.network ?? ""))", systemImage: "safari", isLast: false, style: service.themeStyle, action: {
                        guard let url = URL(string: store.getScannerUrl(data.network ?? "") + (data.blockHash ?? "")) else {
                            #if os(iOS)
                            HapticFeedback.errorHapticFeedback()
                            #endif
                            return
                        }

                        walletRouter.route(to: \.safari, url)
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
