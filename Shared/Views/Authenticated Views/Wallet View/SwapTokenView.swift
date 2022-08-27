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
    @State private var swapQuote: SwapQuote?

    init(service: AuthenticatedServices) {
        self.service = service
        self.store = service.wallet
    }

    var body: some View {
        BackgroundColorView(style: service.themeStyle, {
            VStack {
                ScrollView(.vertical, showsIndicators: true) {
                    ZStack(alignment: .center) {
                        VStack(alignment: .center, spacing: 5) {
                            ListSection(hasPadding: false, style: service.themeStyle) {
                                VStack(alignment: .leading, spacing: 0) {
                                    Text("Send")
                                        .fontTemplate(DefaultTemplate.caption_Mono_secondary)

                                    HStack(alignment: .center, spacing: 0) {
                                        Button(action: {
                                            print("Select Send Token")
                                            walletRouter.route(to: \.swapListToken, true)
                                        }, label: {
                                            HStack(alignment: .center, spacing: 10) {
                                                ZStack {
                                                    RemoteImage(store.sendToken?.image ?? store.sendToken?.imageThumb ?? "", size: 36)
                                                        .clipShape(Circle())
                                                        .overlay(Circle().strokeBorder(DefaultTemplate.borderColor.opacity(0.8), lineWidth: 1))
                                                        .shadow(color: Color.black.opacity(service.themeStyle == .shadow ? 0.15 : 0.0), radius: 8, x: 0, y: 6)

                                                        if let net = store.sendToken?.network {
                                                            Image((net == "bsc" ? "binance" : net) + "_logo")
                                                                .resizable()
                                                                .scaledToFill()
                                                                .frame(width: 15, height: 15, alignment: .center)
                                                                .clipShape(Circle())
                                                                .overlay(Circle().foregroundColor(.clear).overlay(Circle().stroke(Color("baseBackground_bordered"), lineWidth: 2)))
                                                                .offset(x: -12.5, y: 12.5)
                                                        }
                                                }

                                                VStack(alignment: .leading, spacing: 2.5) {
                                                    HStack(alignment: .center, spacing: 10) {
                                                        Text(store.sendToken?.symbol?.uppercased() ?? "Select Token")
                                                            .fontTemplate(DefaultTemplate.subheadingBold)

                                                        Image(systemName: "chevron.down")
                                                            .resizable()
                                                            .font(Font.title.weight(.bold))
                                                            .scaledToFit()
                                                            .frame(width: 10, height: 14, alignment: .center)
                                                            .foregroundColor(.primary)
                                                    }

                                                    Text("available: \(store.sendToken?.nativeBalance ?? 0.00)")
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

                                        HStack(alignment: .center, spacing: 10) {
                                            BorderedButton(title: "Max", size: .mini, tint: .blue, action: {
                                                print("Max Amount")
                                                self.sendTokenAmount = "\(store.sendToken?.nativeBalance ?? 0.00)"
                                            })

                                            Text(sendTokenAmount.isEmpty ? "0" : sendTokenAmount)
                                                .fontTemplate(DefaultTemplate.headingSemiBold)
                                                .multilineTextAlignment(.trailing)
                                                .adjustsFontSizeToFitWidth(true)
                                                .minimumScaleFactor(0.5)
                                                .lineLimit(1)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 10)
                            }

                            ListSection(hasPadding: false, style: service.themeStyle) {
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("Receive (estimated)")
                                        .fontTemplate(DefaultTemplate.caption_Mono_secondary)

                                    HStack {
                                        Button(action: {
                                            walletRouter.route(to: \.swapListToken, false)
                                        }, label: {
                                            HStack(alignment: .center, spacing: 10) {
                                                ZStack {
                                                    RemoteImage(store.receiveToken?.image ?? store.receiveToken?.imageThumb ?? store.receiveSwapToken?.logoURI ?? "", size: 36)
                                                        .clipShape(Circle())
                                                        .overlay(Circle().strokeBorder(DefaultTemplate.borderColor.opacity(0.8), lineWidth: 1))
                                                        .shadow(color: Color.black.opacity(service.themeStyle == .shadow ? 0.15 : 0.0), radius: 8, x: 0, y: 6)

                                                        if (store.receiveToken != nil || store.receiveSwapToken != nil),
                                                           !(store.receiveSwapToken?.tags?.contains(where: { $0 == .native }) ?? false),
                                                            let net = store.sendToken?.network {
                                                            Image((net == "bsc" ? "binance" : net) + "_logo")
                                                                .resizable()
                                                                .scaledToFill()
                                                                .frame(width: 15, height: 15, alignment: .center)
                                                                .clipShape(Circle())
                                                                .overlay(Circle().foregroundColor(.clear).overlay(Circle().stroke(Color("baseBackground_bordered"), lineWidth: 2)))
                                                                .offset(x: -12.5, y: 12.5)
                                                        }
                                                }

                                                VStack(alignment: .leading, spacing: 2.5) {
                                                    HStack(alignment: .center, spacing: 10) {
                                                        Text(store.receiveToken?.symbol?.uppercased() ?? store.receiveSwapToken?.displayedSymbol?.uppercased() ?? store.receiveSwapToken?.symbol?.uppercased() ?? "Select Token")
                                                            .fontTemplate(DefaultTemplate.subheadingBold)
                                                            .lineLimit(1)

                                                        Image(systemName: "chevron.down")
                                                            .resizable()
                                                            .font(Font.title.weight(.bold))
                                                            .scaledToFit()
                                                            .frame(width: 10, height: 14, alignment: .center)
                                                            .foregroundColor(.primary)
                                                    }

                                                    if let receiveAmount = store.receiveToken?.nativeBalance {
                                                        Text("available: \(receiveAmount)")
                                                            .fontTemplate(DefaultTemplate.caption)
                                                            .adjustsFontSizeToFitWidth(true)
                                                            .minimumScaleFactor(0.85)
                                                            .lineLimit(1)
                                                    }
                                                }
                                            }
                                        })
                                        .contentShape(Rectangle())
                                        .buttonStyle(ClickInteractiveStyle(0.98))
                                        Spacer()

                                        let amount: Double = Double(self.swapQuote?.toTokenAmount ?? "0") ?? 0
                                        let dec: Double = Double(self.swapQuote?.toToken?.decimals?.decimalToNumber() ?? 0)
                                        Text(self.swapQuote?.toTokenAmount != nil ? "\(amount / dec)" : "0")
                                            .fontTemplate(DefaultTemplate.headingSemiBold)
                                            .adjustsFontSizeToFitWidth(true)
                                            .minimumScaleFactor(0.6)
                                            .lineLimit(1)
                                    }
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 10)
                            }
                        }
                        .padding(12.5)

                        Button(action: {
                            if store.sendToken != nil, store.receiveToken != nil {
                                let tempSend = store.sendToken
                                store.sendToken = store.receiveToken
                                store.receiveToken = tempSend

                                let decimalMultiplier = store.receiveToken?.decimals?.decimalToNumber() ?? store.receiveSwapToken?.decimals?.decimalToNumber() ?? Int(Constants.eighteenDecimal)
                                let sendAmount = Double(self.sendTokenAmount) ?? 0.0
    //                            let newAmount = sendAmount * Double(decimalMultiplier)

                                store.getSwapQuote(amount: "\(Int(sendAmount * Double(decimalMultiplier)))", completion: { result, error in
                                    print("done updating swap quote. result: \(String(describing: result)) && error: \(String(describing: error))")
                                    self.disablePrimaryAction = error != nil
                                    self.swapQuote = result
                                })
                            }
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

                    // Swap Value in currency (usd)
                    // gas price in GWei & currency (usd) option to change speed?
                    // slippage amount with action
                    // transaction total fee

                    ListSection(title: "Summary", style: service.themeStyle) {
                        let conversion = ((store.sendToken?.totalBalance ?? 0.0) / (store.sendToken?.nativeBalance ?? 0.0)) * (Double(self.sendTokenAmount) ?? 0.00)

                        ListInfoSmallView(title: "Swap Value", info: Double(self.sendTokenAmount) ?? 0 <= 0 ? "-" : "~" + conversion.convertToCurrency(), style: service.themeStyle, isLast: false)

                        ListInfoSmallButton(title: "Gas Fee",
                                            info: self.swapQuote?.estimatedGas != nil ? "\(self.swapQuote?.estimatedGas?.formatCommas() ?? "0") GWei" : "-",
                                            subinfo: nil, systemImage: "fuelpump.fill",
                                            isLast: false, hasHaptic: false,
                                            style: service.themeStyle, action: {
                            print("open gas sheet")
                        })

                        ListInfoSmallButton(title: "Slippage Tolerance", info: "3.00%", subinfo: nil, isLast: true, hasHaptic: false, style: service.themeStyle, action: {
                            print("open slippage sheet")
                        })
                    }
                }

                RoundedInteractiveButton("Preview Swap", isDisabled: $disablePrimaryAction, style: .primary, systemImage: nil, action: {
                    if let swapQuote = swapQuote {
                        walletRouter.route(to: \.swapTokenDetail, swapQuote)
                    }
                })
                .padding([.horizontal, .bottom])

                KeypadView(value: $sendTokenAmount)
                    .frame(maxWidth: Constants.iPadMaxWidth)
                    .padding(.bottom, 30)
            }.ignoresSafeArea(.all, edges: .bottom)
        })
        .navigationBarTitle("Swap Tokens", displayMode: .inline)
        .onChange(of: self.sendTokenAmount, perform: { value in
            guard let amount = Double(value), amount > 0,
                  store.sendToken != nil, (store.receiveToken != nil || store.receiveSwapToken != nil) else {
                self.disablePrimaryAction = true
                return
            }

            let decimalMultiplier = store.receiveToken?.decimals?.decimalToNumber() ?? store.receiveSwapToken?.decimals?.decimalToNumber() ?? Int(Constants.eighteenDecimal)
            let newAmount = amount * Double(decimalMultiplier)

            guard !(newAmount.isNaN || newAmount.isInfinite) else {
                 return
             }

            store.getSwapQuote(amount: "\(Int(newAmount))", completion: { result, error in
                print("done updating swap quote. result: \(String(describing: result)) && error: \(String(describing: error))")
                self.disablePrimaryAction = error != nil
                self.swapQuote = result
            })
        })
        .onChange(of: self.store.sendToken, perform: { _ in
            self.sendTokenAmount = "0"
            self.swapQuote = nil
            self.disablePrimaryAction = true
        })
        .onChange(of: self.store.receiveToken, perform: { value in
            if value != nil, let amount = Double(sendTokenAmount), amount > 0 {
                let decimalMultiplier = store.receiveToken?.decimals?.decimalToNumber() ?? store.receiveSwapToken?.decimals?.decimalToNumber() ?? Int(Constants.eighteenDecimal)
                let newAmount = amount * Double(decimalMultiplier)

                store.getSwapQuote(amount: "\(Int(newAmount))", completion: { result, error in
                    print("done updating swap quote. result: \(String(describing: result)) && error: \(String(describing: error))")
                    self.disablePrimaryAction = error != nil
                    self.swapQuote = result
                })
            } else {
                self.disablePrimaryAction = true
                self.swapQuote = nil
            }
        })
        .onChange(of: self.store.receiveSwapToken, perform: { value in
            if value != nil, let amount = Double(sendTokenAmount), amount > 0 {
                let decimalMultiplier = store.receiveToken?.decimals?.decimalToNumber() ?? store.receiveSwapToken?.decimals?.decimalToNumber() ?? Int(Constants.eighteenDecimal)
                let newAmount = amount * Double(decimalMultiplier)

                store.getSwapQuote(amount: "\(Int(newAmount))", completion: { result, error in
                    print("done updating swap quote. result: \(String(describing: result)) && error: \(String(describing: error))")
                    self.disablePrimaryAction = error != nil
                    self.swapQuote = result
                })
            } else {
                self.disablePrimaryAction = true
                self.swapQuote = nil
            }
        })
        .onAppear {
            DispatchQueue.main.async {
                Tool.hiddenTabBar()
            }

            if let nativeToken = self.store.accountBalance?.completeBalance?.max(by: { $0.nativeBalance?.totalBalance ?? 0 < $1.nativeBalance?.totalBalance ?? 0 }) {
                self.store.sendToken = nativeToken.nativeBalance
                print("set local native token: \(self.store.sendToken?.name ?? "nil")")
            }

            self.store.loadSwappableTokens(completion: { swapTokens in
                guard let swapTokens = swapTokens else { return }

                self.store.getAccountSwappableTokens(swapTokens, completion: { tokens in
                    print("got all the tokens: \(tokens?.count ?? 0)")
                })
            })
        }
    }

}
