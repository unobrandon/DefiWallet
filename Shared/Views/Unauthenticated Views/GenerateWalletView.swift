//
//  CreateWalletView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/26/22.
//

import SwiftUI

struct GenerateWalletView: View {

    @EnvironmentObject private var unauthenticatedRouter: UnauthenticatedCoordinator.Router

    @ObservedObject private var store: UserOnboardingServices

    @State var doneGenerating: Bool = false
    @State var ethAddress: Double = 0

    private let timer = Timer.publish(every: 0.25, on: .main, in: .common).autoconnect()

    init(services: UnauthenticatedServices) {
        self.store = services.userOnboarding
    }

    var body: some View {
        ZStack(alignment: .center) {
            Color("baseBackground").ignoresSafeArea()

            VStack(alignment: .center, spacing: 10) {

                if !doneGenerating {
                    HStack(alignment: .center, spacing: 0) {
                        Text("0x").fontTemplate(DefaultTemplate.monospace)

                        MovingNumbersView(number: ethAddress, numberOfDecimalPlaces: 0, fixedWidth: 50, showComma: false) { str in
                            Text(self.customLabelMapping(str))
                                .fontTemplate(DefaultTemplate.monospace)
                        }
                        .mask(AppGradients.movingNumbersMask)

                        Text("...").fontTemplate(DefaultTemplate.monospace)

                        MovingNumbersView(number: ethAddress, numberOfDecimalPlaces: 0, fixedWidth: 50, showComma: false) { str in
                            Text(self.customLabelMapping(str))
                                .fontTemplate(DefaultTemplate.monospace)
                        }
                        .mask(AppGradients.movingNumbersMask)
                    }
                    .padding(5)
                    .background(RoundedRectangle(cornerRadius: 3).foregroundColor(Color("baseButton")))
                    .onReceive(timer) { _ in
                        let low: Int = 10000000
                        let high: Int = 99999999
                        let randomInt = Int.random(in: low..<high)
                        self.ethAddress = Double(randomInt)
                    }
                } else {
                    Text(store.generatedAddrress.formatAddressExtended())
                        .fontTemplate(DefaultTemplate.monospace)
                        .padding(5)
                        .background(RoundedRectangle(cornerRadius: 3).foregroundColor(Color("baseButton")))
                        .mask(AppGradients.movingNumbersMask)
                }

                VStack(alignment: .center, spacing: 10) {
                    Text(!doneGenerating ? "generating..." : "success!")
                        .fontTemplate(DefaultTemplate.body)

                    if doneGenerating {
                        CheckmarkView(size: 30)
                            .onAppear {
                                store.generatedAddrress = "0x41914acD93d82b59BD7935F44f9b44Ff8381FCB9"
                            }
                    }
                }
            }
        }
        .navigationBarTitle( "Generat\(doneGenerating ? "ed" : "ing") Wallet", displayMode: .inline)
        #if os(iOS)
        .navigationBarBackButtonHidden(true)
        #endif
        .onAppear {
            guard store.generatedAddrress.isEmpty else {
                unauthenticatedRouter.popToRoot()

                return
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + store.generateWalletDelay) {
                withAnimation {
                    doneGenerating = true
                }
                self.timer.upstream.connect().cancel()

                #if os(iOS)
                    HapticFeedback.successHapticFeedback()
                #endif

                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    unauthenticatedRouter.route(to: \.setPassword)
                }
            }
        }
        .onDisappear {
            self.timer.upstream.connect().cancel()
        }
    }

    private func customLabelMapping(_ label: String) -> String {
        guard let number = Int(label) else { return label }
        let emojis = ["d", "t", "S", "3", "P", "k", "b", "2", "a", "z", "b", "5", "K", "Q", "9", "n", "0", "1", "y", "r", "G", "z"]

        return emojis[number]
    }

}
