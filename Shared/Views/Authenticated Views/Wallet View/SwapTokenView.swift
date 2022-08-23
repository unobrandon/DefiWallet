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

                                HStack(alignment: .center, spacing: 10) {
                                    Button(action: {
                                        print("Select Send Token")
                                    }, label: {
                                        HStack(alignment: .center, spacing: 10) {
                                            RemoteImage("", size: 36)
                                                .clipShape(Circle())
                                                .overlay(Circle().strokeBorder(DefaultTemplate.borderColor.opacity(0.8), lineWidth: 1))
                                                .shadow(color: Color.black.opacity(service.themeStyle == .shadow ? 0.15 : 0.0), radius: 8, x: 0, y: 6)

                                            VStack(alignment: .leading, spacing: 2.5) {
                                                HStack(alignment: .center, spacing: 10) {
                                                    Text("ETH")
                                                    .fontTemplate(DefaultTemplate.sectionHeader_bold)

                                                    Image(systemName: "chevron.down")
                                                        .resizable()
                                                        .font(Font.title.weight(.bold))
                                                        .scaledToFit()
                                                        .frame(width: 10, height: 14, alignment: .center)
                                                        .foregroundColor(.primary)
                                                }

                                                Text("available: 0.238")
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

                                    BorderedButton(title: "Max", size: .mini, tint: .blue, action: {
                                        print("Max Amount")
                                    })

                                    VStack(alignment: .trailing, spacing: 0) {
                                        Text(sendTokenAmount.isEmpty ? "0" : sendTokenAmount)
                                            .fontTemplate(DefaultTemplate.headingSemiBold)
                                            .adjustsFontSizeToFitWidth(true)
                                            .minimumScaleFactor(0.75)
                                            .lineLimit(1)

                                        Text("-")
                                            .fontTemplate(DefaultTemplate.body_secondary)
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
                                        print("Select Token")
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

            self.store.loadSwappableTokens(completion: { swapTokens in
                guard let swapTokens = swapTokens else { return }

                self.store.getAccountSwappableTokens(swapTokens, completion: { tokens in
                    print("got all the tokens: \(tokens?.count ?? 0)")
                })
            })
        }
    }

}
