//
//  TransactionDetailView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 3/21/22.
//

import SwiftUI

struct TransactionDetailView: View {

    @EnvironmentObject private var walletRouter: WalletCoordinator.Router

    @ObservedObject private var service: AuthenticatedServices
    @ObservedObject private var store: WalletService

    private let data: HistoryData

    init(data: HistoryData, service: AuthenticatedServices) {
        self.service = service
        self.store = service.wallet
        self.data = data
    }

    var body: some View {
        BackgroundColorView(style: service.themeStyle, {
            ScrollView {
                VStack(alignment: .center, spacing: 5) {
                    ZStack {
                        StandardSystemImage(service.wallet.transactionImage(data.direction),
                                            color: service.wallet.transactionColor(data.direction),
                                            size: 64, cornerRadius: 32, style: service.themeStyle)

                        service.wallet.getNetworkImage(data.network)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 24, height: 24, alignment: .center)
                            .clipShape(Circle())
                            .overlay(Circle().foregroundColor(.clear).overlay(Circle().stroke(Color("baseBackground_bordered"), lineWidth: 3.5)))
                            .offset(x: -22, y: 22)
                    }

                    Text(data.direction == .incoming ? "Received" : data.direction == .outgoing ? "Sent" : "Exchanged").fontTemplate(DefaultTemplate.headingSemiBold)
                        .padding(.top, 30)

                    Text((data.direction == .outgoing ? "-" : "") + "\("".forTrailingZero(temp: Double(data.amount)?.truncate(places: 8) ?? 0.00)) \(data.symbol.prefix(8))")
                        .fontTemplate(FontTemplate(font: Font.custom("Poppins-SemiBold", size: 36),
                                                   weight: .semibold,
                                                   foregroundColor: data.direction == .outgoing ? .red : data.direction == .outgoing ? .green : .blue, lineSpacing: 0))
                        .irregularGradient(colors: data.direction == .outgoing ? [Color("alertRed"), .orange] : data.direction == .incoming ? [Color("darkGreen"), .green] : [Color("accentColor"), .teal],
                                           background: data.direction == .outgoing ? Color("alertRed") : data.direction == .incoming ? Color.green : Color("AccentColor"))

                    Text(Date(timeIntervalSince1970: Double(data.timeStamp) ?? 0.0).mediumDateFormate())
                        .fontTemplate(DefaultTemplate.body_secondary)
                }
                .padding(.vertical, 40)

                ListSection(style: service.themeStyle) {
                    if let fromEthNameService = data.fromEns {
                        ListInfoView(title: "From", info: fromEthNameService, style: service.themeStyle, isLast: false)
                    } else {
                        ListInfoView(title: "From", info: data.from.formatAddressExtended(), style: service.themeStyle, isLast: false)
                    }

                    if let toEthNameService = data.destinationEns {
                        ListInfoView(title: "To", info: toEthNameService, style: service.themeStyle, isLast: true)
                    } else {
                        ListInfoView(title: "To", info: data.destination.formatAddressExtended(), style: service.themeStyle, isLast: true)
                    }
                }

                ListSection(title: "Details", style: service.themeStyle) {
                    ListInfoView(title: "Hash", info: data.hash.formatAddressExtended(), style: service.themeStyle, isLast: false)

                    ListInfoCustomView(title: "Status", style: service.themeStyle, isLast: false) {
                        BorderedButton(title: data.txSuccessful ? "Successful" : "FAILED",
                                       systemImage: data.txSuccessful ? "checkmark.circle.fill" : "xmark.octagon.fill",
                                       size: .mini, tint: data.txSuccessful ? Color.green : Color.red, action: {  })
                            .frame(height: 22)
                    }

                    ListInfoView(title: "Network", info: data.network.rawValue, style: service.themeStyle, isLast: false)

                    ListInfoView(title: "Gas Fee", info: "\(data.gasPrice.truncate(places: 10))" + " " + data.symbol.prefix(8), style: service.themeStyle, isLast: false)

                    ListInfoView(title: "Gas Limit", info: "\(data.gasLimit.truncate(places: 10))" + " " + data.symbol.prefix(8), style: service.themeStyle, isLast: false)

                    ListInfoView(title: "Block", info: "\(data.blockNumber)", style: service.themeStyle, isLast: false)

                    if let nonce = data.nonce {
                        ListInfoView(title: "Nonce", info: nonce, style: service.themeStyle, isLast: true)
                    }
                }

                ListSection(title: "More", style: service.themeStyle) {
                    ListStandardButton(title: "View on \(store.getBlockExplorerName(data.network))", systemImage: "safari", isLast: false, style: service.themeStyle, action: {
                        guard let url = URL(string: store.getScannerUrl(data.network) + data.hash) else {
                            #if os(iOS)
                            HapticFeedback.errorHapticFeedback()
                            #endif
                            return
                        }

                        walletRouter.route(to: \.safari, url)
                        #if os(iOS)
                            HapticFeedback.rigidHapticFeedback()
                        #endif
                    })

                    ListStandardButton(title: "Share transaction", systemImage: "square.and.arrow.up", isLast: true, style: service.themeStyle, action: {
                        guard let url = URL(string: store.getScannerUrl(data.network) + data.hash) else {
                            #if os(iOS)
                            HapticFeedback.errorHapticFeedback()
                            #endif
                            return
                        }

                        store.shareSheet(url: url)
                        #if os(iOS)
                            HapticFeedback.rigidHapticFeedback()
                        #endif
                    })
                }
                .padding(.bottom)
            }
        })
        .navigationBarTitle("Details", displayMode: .inline)
    }

}
