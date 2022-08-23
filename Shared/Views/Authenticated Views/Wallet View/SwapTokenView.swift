//
//  SwapTokenView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 6/18/22.
//

import SwiftUI

struct SwapTokenView: View {

    @EnvironmentObject private var walletRouter: WalletCoordinator.Router

    @ObservedObject private var service: AuthenticatedServices
    @ObservedObject private var store: WalletService

    @State var showSheet: Bool = false

    @State var sendTokenAmount: String = ""
    @State var disablePrimaryAction: Bool = true

    @State var sendToken: TokenModel?
    @State var receiveToken: TokenModel?
    @State var accountSendingTokens: [TokenModel]?

    init(service: AuthenticatedServices) {
        self.service = service
        self.store = service.wallet
    }

    var body: some View {
        BackgroundColorView(style: service.themeStyle, {
            VStack {
                Spacer()
                ZStack(alignment: .center) {
                    VStack(alignment: .center, spacing: 5) {
                        ListSection(hasPadding: false, style: service.themeStyle) {
                            VStack(alignment: .leading, spacing: 0) {
                                Text("Send")
                                    .fontTemplate(DefaultTemplate.caption_Mono_secondary)

                                HStack(alignment: .center, spacing: 0) {
                                    Button(action: {
                                        print("Select Send Token")
                                        walletRouter.route(to: \.swapListToken, self.accountSendingTokens)
                                    }, label: {
                                        HStack(alignment: .center, spacing: 10) {
                                            RemoteImage(sendToken?.image, size: 36)
                                                .clipShape(Circle())
                                                .overlay(Circle().strokeBorder(DefaultTemplate.borderColor.opacity(0.8), lineWidth: 1))
                                                .shadow(color: Color.black.opacity(service.themeStyle == .shadow ? 0.15 : 0.0), radius: 8, x: 0, y: 6)

                                            VStack(alignment: .leading, spacing: 2.5) {
                                                HStack(alignment: .center, spacing: 10) {
                                                    Text(sendToken?.symbol?.uppercased() ?? "-")
                                                        .fontTemplate(DefaultTemplate.sectionHeader_bold)

                                                    Image(systemName: "chevron.down")
                                                        .resizable()
                                                        .font(Font.title.weight(.bold))
                                                        .scaledToFit()
                                                        .frame(width: 10, height: 14, alignment: .center)
                                                        .foregroundColor(.primary)
                                                }

                                                Text("available: \(sendToken?.nativeBalance ?? 0.0)")
                                                    .fontTemplate(DefaultTemplate.caption)
                                                    .adjustsFontSizeToFitWidth(true)
                                                    .minimumScaleFactor(0.85)
                                                    .lineLimit(1)
                                            }
                                        }
                                    })
                                    .contentShape(Rectangle())
                                    .buttonStyle(ClickInteractiveStyle(0.98))
                                    Spacer()

                                    VStack(alignment: .trailing, spacing: 0) {
                                        HStack(alignment: .center, spacing: 10) {
                                            BorderedButton(title: "Max", size: .mini, tint: .blue, action: {
                                                print("Max Amount")
                                                self.sendTokenAmount = "\(self.sendToken?.nativeBalance ?? 0.00)"
                                            })

                                            Text(sendTokenAmount.isEmpty ? "0" : sendTokenAmount)
                                                .fontTemplate(DefaultTemplate.headingSemiBold)
                                                .adjustsFontSizeToFitWidth(true)
                                                .minimumScaleFactor(0.5)
                                                .lineLimit(1)
                                                .frame(minWidth: 40)
                                                .multilineTextAlignment(.trailing)
                                        }

                                        let conversion = ((sendToken?.totalBalance ?? 0.0) / (sendToken?.nativeBalance ?? 0.0)) * (Double(self.sendTokenAmount) ?? 0.00)

                                        Text(Double(self.sendTokenAmount) ?? 0 <= 0 ? "-" : conversion.convertToCurrency())
                                            .fontTemplate(DefaultTemplate.body_secondary)
                                            .minimumScaleFactor(0.65)
                                            .lineLimit(1)
                                            .multilineTextAlignment(.trailing)
                                    }
                                }
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                        }

                        ListSection(hasPadding: false, style: service.themeStyle) {
                            VStack(alignment: .leading, spacing: 0) {
                                Text("Receive (estimated)")
                                    .fontTemplate(DefaultTemplate.caption_Mono_secondary)

                                HStack {
                                    Button(action: {
                                        walletRouter.route(to: \.swapListToken, self.accountSendingTokens)
                                    }, label: {
                                        HStack(alignment: .center, spacing: 10) {
                                            RemoteImage("", size: 36)
                                                .clipShape(Circle())
                                                .overlay(Circle().strokeBorder(DefaultTemplate.borderColor.opacity(0.8), lineWidth: 1))
                                                .shadow(color: Color.black.opacity(service.themeStyle == .shadow ? 0.15 : 0.0), radius: 8, x: 0, y: 6)

                                            Text("Select Token")
                                                .fontTemplate(DefaultTemplate.subheadingBold)

                                            Image(systemName: "chevron.down")
                                                .resizable()
                                                .font(Font.title.weight(.bold))
                                                .scaledToFit()
                                                .frame(width: 10, height: 14, alignment: .center)
                                                .foregroundColor(.primary)
                                        }
                                    })
                                    .contentShape(Rectangle())
                                    .buttonStyle(ClickInteractiveStyle(0.98))

                                    Spacer()

                                    VStack(alignment: .trailing, spacing: 0) {
                                        Text("0")
                                            .fontTemplate(DefaultTemplate.headingSemiBold)

                                        Text("-")
                                            .fontTemplate(DefaultTemplate.body_secondary)
                                    }
                                }
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                        }
                    }
                    .padding(12.5)

                    Button(action: {
                        print("flip tokens")
                    }, label: {
                        Image(systemName: "arrow.up.arrow.down")
                            .resizable()
                            .sizeToFit()
                            .frame(height: 16, alignment: .center)
                            .foregroundColor(.primary)
                            .padding(10)
                            .background(Color("baseButton"))
                            .overlay(Circle().strokeBorder(DefaultTemplate.borderColor.opacity(service.themeStyle == .border ? 1.0 : 0.0), lineWidth: 0.8))
                    })
                    .buttonStyle(ClickInteractiveStyle(0.92))
                    .clipShape(Circle())
                    .shadow(color: Color.black.opacity(service.themeStyle == .shadow ? 0.15 : 0.0), radius: 15, x: 0, y: 8)
                }

                // MARK: Other Options Section

                // gas price transact speed slider
                // slippage amount with action
                // transaction total fee

                ListSection(title: "Summary", style: service.themeStyle) {
                    Text("Hello world")
                }

                Spacer()
                RoundedInteractiveButton("Preview Swap", isDisabled: $disablePrimaryAction, style: .primary, systemImage: nil, action: {
                    print("Swap token action.")
                })
                .padding([.horizontal, .bottom])

                KeypadView(value: $sendTokenAmount)
                    .frame(maxWidth: Constants.iPadMaxWidth)
                    .padding(.bottom, 30)
            }.ignoresSafeArea()
        })
        .navigationBarTitle("Swap Tokens", displayMode: .inline)
        .onAppear {
            DispatchQueue.main.async {
                Tool.hiddenTabBar()
            }

            if let nativeToken = self.store.accountBalance?.completeBalance?.max(by: { $0.nativeBalance?.totalBalance ?? 0 < $1.nativeBalance?.totalBalance ?? 0 }) {
                self.sendToken = nativeToken.nativeBalance
                print("set local native token: \(self.sendToken?.name ?? "nil")")
            }

            self.store.loadSwappableTokens(completion: { swapTokens in
                guard let swapTokens = swapTokens else { return }

                self.store.getAccountSwappableTokens(swapTokens, completion: { tokens in
                    print("got all the tokens: \(tokens?.count ?? 0)")

                    self.sendToken = tokens?.first
                    self.accountSendingTokens = tokens
                })
            })
        }
    }

}
