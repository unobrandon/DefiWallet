//
//  WalletView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/13/22.
//

import SwiftUI
import Stinsen
import SwiftUICharts

struct WalletView: View {

    @ObservedObject private var service: AuthenticatedServices

    @ObservedObject private var store: WalletService

    @State private var showSheet = false

    init(service: AuthenticatedServices) {
        self.service = service
        self.store = service.wallet

        self.fetchHistory()
    }

    var body: some View {
        BackgroundColorView(style: service.themeStyle, {
            ScrollView {

                HStack(alignment: .center, spacing: 10) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Total Balance:")
                            .fontTemplate(DefaultTemplate.body_secondary)

                        HStack(alignment: .center, spacing: 0) {
                            Text("$").fontTemplate(DefaultTemplate.titleBold)

                            MovingNumbersView(number: 18.93,
                                              numberOfDecimalPlaces: 2,
                                              fixedWidth: 260,
                                              showComma: true) { str in
                                Text(str).fontTemplate(DefaultTemplate.titleBold)
                            }
                        }.mask(AppGradients.movingNumbersMask)
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top)

                LineChart(data: [90,99,78,111,70,60,77],
                          frame: CGRect(x: 20, y: 0, width: MobileConstants.screenWidth - 40, height: 160),
                          visualType: ChartVisualType.filled(color: Color("AccentColor"), lineWidth: 3), offset: 0,
                          currentValueLineType: CurrentValueLineType.dash(color: .secondary, lineWidth: 2, dash: [8]))
                    .frame(height: 160)
                    .padding()

                TransactButtonView(style: service.themeStyle,
                                   enableDeposit: true,
                                   enableSend: true,
                                   enableReceive: true,
                                   enableSwap: true,
                                   actionDeposit: {
                    print("deposit")
                }, actionSend: {
                    print("send")
                }, actionReceive: {
                    print("receive")
                }, actionSwap: {
                    print("swap")
                }).padding(.top)

                SectionHeaderView(title: "Networks", action: {
                    print("see more")
                })

                ListSection(style: service.themeStyle) {
                    ForEach(store.completeBalance, id: \.self) { item in
                        HStack(alignment: .center) {
                            VStack(alignment: .leading, spacing: 2.5) {
                                Text(item.network ?? "unknown")
                                    .fontTemplate(DefaultTemplate.bodySemibold)

                                if let tokenCount = item.tokenBalance?.count, tokenCount != 0 {
                                    Text("+\(tokenCount) tokens")
                                        .fontTemplate(DefaultTemplate.caption)
                                }

                                if let nfts = item.nfts, let nftCount = nfts.result?.count, nftCount != 0 {
                                    Text("+\(nftCount) collectables")
                                        .fontTemplate(DefaultTemplate.caption)
                                }
                            }

                            Spacer()
                            if let native = item.nativeBalance,
                               let balance = Double(native),
                               let formatted = (balance / Constants.eighteenDecimal),
                               let roundedValue = formatted.truncate(places: 4),
                               let network = item.network?.formatNetwork() {
                                Text("".forTrailingZero(temp: roundedValue) + " " + network)
                                    .font(Font.custom("Poppins-SemiBold", size: 14))
                                    .foregroundColor(Color.primary)
                                    .textCase(.uppercase)
                            }
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal)
                        .background(.secondary.opacity(0.2))
                    }
                }

                if !store.history.isEmpty {
                    SectionHeaderView(title: "History", actionTitle: "See more", action: {
                        print("see more")
                    })
                    .padding(.top)
                }

                ForEach(store.history, id: \.self) { item in
                    HStack(alignment: .center) {
                        VStack(alignment: .leading, spacing: 2.5) {
                            Text(item.direction == .incoming ? "Received" : item.direction == .outgoing ? "Sent" : "Exchange")
                                .fontTemplate(DefaultTemplate.bodyBold)

                            Text("\(item.amount) \(item.symbol)")
                                .fontTemplate(DefaultTemplate.bodyMedium)
                        }

                        Spacer()
                        VStack(alignment: .trailing, spacing: 2.5) {
                            Text("\(item.timeStamp.getFullElapsedInterval())")
                                .fontTemplate(DefaultTemplate.caption)

                            if let fromAddress = item.fromEns == nil ? item.from : item.fromEns {
                                Text("from: " + "\("".formatAddress(fromAddress))")
                                    .fontTemplate(DefaultTemplate.caption)
                            }
                        }
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal)
                    .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.secondary.opacity(0.2)))
                    .padding(.horizontal)
                }
            }
        })
        .navigationBarTitle("", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                WalletNavigationView(service: service).offset(y: -2.5)
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                HStack(alignment: .center, spacing: 10) {
                    Button {
                        UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
                        SOCManager.present(isPresented: $showSheet) {
                            ScanQRView(showSheet: $showSheet, service: service, actionScan: { uriLink in
                                store.connectDapp(uri: uriLink, completion: { success in
                                    if success {
                                        // call a dismiss maybe
                                    } else {
                                        // reset scan screen
                                    }
                                })
                            })
                            #if os(macOS)
                            .frame(height: 400, alignment: .center)
                            #elseif os(iOS)
                            .frame(minHeight: MobileConstants.screenHeight / 2.5, maxHeight: MobileConstants.screenHeight / 1.75, alignment: .center)
                            #endif
                        }
                    } label: {
                        Image(systemName: "qrcode.viewfinder")
                    }
                    .foregroundColor(Color.primary)
                }
            }
        }
        .slideOverCard(isPresented: $showSheet) {

        }
    }

    private func fetchHistory() {
        store.fetchHistory(service.currentUser.address, completion: {
            print("done getting history")
        })

        store.fetchAccountBalance(service.currentUser.address, completion: {
            print("completed getting chain overview: \(store.accountBalance.count)")
        })
    }

}
