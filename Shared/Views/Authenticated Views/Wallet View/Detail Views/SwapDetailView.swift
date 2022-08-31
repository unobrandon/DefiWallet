//
//  SwapDetailView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 8/27/22.
//

import SwiftUI

struct SwapDetailView: View {

    @EnvironmentObject private var walletRouter: WalletCoordinator.Router

    @ObservedObject private var service: AuthenticatedServices
    @ObservedObject private var store: WalletService
    @State var swapRequestTimer: Timer?

    private let swapQuote: SwapQuote

    init(swapQuote: SwapQuote, service: AuthenticatedServices) {
        self.service = service
        self.store = service.wallet
        self.swapQuote = swapQuote
    }

    var body: some View {
        BackgroundColorView(style: service.themeStyle, {
            ScrollView(.vertical, showsIndicators: true) {
                VStack(alignment: .center, spacing: 5) {
                    ListSection(title: "Tokens", style: service.themeStyle) {
                        Text("Gas: \(store.swapResult?.transaction?.gas ?? 0)")
                            .fontTemplate(DefaultTemplate.headingBold)
                    }
                }
            }
        })
        .safeAreaInset(edge: .bottom) {
            Button(action: {
                print("swap tokens")
            }, label: {
                HStack(alignment: .center, spacing: 10) {
                    Spacer()
                    if store.isLoadingSwapAction {
                        LoadingIndicator(size: 24, color: Color("baseButton"))
                    } else {
                        Text("Swap Tokens")
                            .fontTemplate(DefaultTemplate.primaryButton)
                    }
                    Spacer()
                }
                .background(RoundedRectangle(cornerRadius: 10, style: .circular)
                                .foregroundColor(store.disablePrimaryAction ? Color("disabledGray") : Color("AccentColor")).frame(height: 49))
                .foregroundColor(store.disablePrimaryAction ? .secondary : Color("AccentColor"))
            })
            .frame(maxWidth: 380)
            .buttonStyle(ClickInteractiveStyle(0.99))
            .padding(.horizontal)
        }
        .navigationBarTitle("Swap Overview", displayMode: .inline)
        .onAppear {
            DispatchQueue.main.async {
                Tool.hiddenTabBar()
            }

            self.service.socket.emitSwapQuoteUpdate(network: store.sendToken?.network?.format1InchNetwork() ?? "1",
                                                    fromTokenAddress: swapQuote.fromToken?.address ?? "",
                                                    toTokenAddress: swapQuote.toToken?.address ?? "",
                                                    signingAddress: store.currentUser.address,
                                                    amount: swapQuote.fromTokenAmount ?? "", slippage: "3")
            startSwapRequestTimer()
        }
        .onDisappear {
            stopSwapRequestTimer()
//            store.swapResult = nil
        }
    }

    func startSwapRequestTimer() {
        self.swapRequestTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
            self.service.socket.emitSwapQuoteUpdate(network: store.sendToken?.network?.format1InchNetwork() ?? "1",
                                                    fromTokenAddress: swapQuote.fromToken?.address ?? "",
                                                    toTokenAddress: swapQuote.toToken?.address ?? "",
                                                    signingAddress: store.currentUser.address,
                                                    amount: swapQuote.fromTokenAmount ?? "", slippage: "3")
        }
    }

    func stopSwapRequestTimer() {
        guard let timer = swapRequestTimer else { return }

        timer.invalidate()
        swapRequestTimer = nil
    }

}
