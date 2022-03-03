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
    @State var isConnecting = false

    private let timer = Timer.publish(every: 0.33, on: .main, in: .common).autoconnect()

    init(services: UnauthenticatedServices) {
        self.store = services.userOnboarding
    }

    var body: some View {
        ZStack(alignment: .center) {
            Color("baseBackground").ignoresSafeArea()

            VStack(alignment: .center, spacing: 10) {

                if doneGenerating && isConnecting {
                    CheckmarkView(size: 45, color: .green)
                        .padding(.bottom)
                } else {
                    HeaderIcon(size: 46, imageName: "arrow.triangle.2.circlepath")
                        .padding(.bottom)
                }

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
                    Text(store.generatedAddress.formatAddressExtended())
                        .fontTemplate(DefaultTemplate.monospace)
                        .padding(5)
                        .background(RoundedRectangle(cornerRadius: 3).foregroundColor(Color("baseButton")))
                        .mask(AppGradients.movingNumbersMask)
                }

                Text(!doneGenerating ? "generating..." : !isConnecting ? "connecting..." : "success!")
                    .fontTemplate(DefaultTemplate.body)
            }
        }
        .navigationBarTitle( "Generat\(doneGenerating && isConnecting ? "ed" : "ing") Wallet", displayMode: .inline)
        #if os(iOS)
        .navigationBarBackButtonHidden(true)
        #endif
        .onAppear {
            guard store.generatedAddress.isEmpty else {
                unauthenticatedRouter.popToRoot()

                return
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + (store.generateWalletDelay * 0.5)) {
                withAnimation {
                    doneGenerating = true
                }
                self.timer.upstream.connect().cancel()
                store.generatedAddress = "0x41914acD93d82b59BD7935F44f9b44Ff8381FCB9"

                #if os(iOS)
                    HapticFeedback.successHapticFeedback()
                #endif

                DispatchQueue.main.asyncAfter(deadline: .now() + (store.generateWalletDelay * 0.2)) {
                    withAnimation {
                        isConnecting = true
                    }

                    DispatchQueue.main.asyncAfter(deadline: .now() + (store.generateWalletDelay * 0.3)) {
                        unauthenticatedRouter.route(to: \.privateKeys)
                    }
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
