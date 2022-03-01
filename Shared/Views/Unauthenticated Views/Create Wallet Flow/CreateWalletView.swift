//
//  CreateWalletView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/26/22.
//

import SwiftUI

struct CreateWalletView: View {

    private let services: UnauthenticatedServices

    @ObservedObject private var store: UserOnboardingServices

    @State var doneGenerating: Bool = false
    @State var ethAddressLength: Double = 0

    let timer = Timer.publish(every: 0.25, on: .main, in: .common).autoconnect()

    var movingNumbersMask: some View {
        return AnyView(LinearGradient(
            gradient: Gradient(stops: [
                Gradient.Stop(color: .clear, location: 0),
                Gradient.Stop(color: .black, location: 0.2),
                Gradient.Stop(color: .black, location: 0.8),
                Gradient.Stop(color: .clear, location: 1.0)]),
            startPoint: .top,
            endPoint: .bottom))
    }

    init(services: UnauthenticatedServices) {
        self.services = services
        self.store = services.userOnboarding
    }

    var body: some View {
        // Play generating animation & show the 'username' +
        // explanation behind subdomain
        ZStack {
            Color("baseBackground").ignoresSafeArea()

            VStack(alignment: .center, spacing: 20) {

                HStack(alignment: .center, spacing: 0) {
                    Text("0x")
                        .fontTemplate(DefaultTemplate.caption)

                    ForEach(0...3, id: \.self) { _ in
                        MovingNumbersView(number: ethAddressLength, numberOfDecimalPlaces: 0, showComma: false) { str in
                            Text(self.customLabelMapping(str))
                                .fontTemplate(DefaultTemplate.caption)
                        }
                        .mask(movingNumbersMask)
                    }
                    .onReceive(timer) { _ in
                        let low: Int = 1000000000
                        let high: Int = 9999999999
                        let randomInt = Int.random(in: low..<high)
                        self.ethAddressLength = Double(randomInt)
                    }
                }

                LoadingIndicator()

                RoundedButton("Show Noti", style: .secondary, systemImage: "paperplane.fill", action: {
                    showNotiHUD(image: "wifi", color: .blue, title: "Connected", subtitle: "")
                })

                TextFieldSingleBordered(text: "", placeholder: "username", systemImage: "person.crop.circle", textLimit: 20, onEditingChanged: { text in
                    print("text changed: \(text)")
                }, onCommit: {
                    print("returned username ehh")
                })

                ListSection(title: "Hello Crypto", style: .shadow) {
                    TextFieldSingleList(text: "", placeholder: "enter 12 or 24 seed phrase here", systemImage: "list.bullet.rectangle", textLimit: nil, isLast: true, onEditingChanged: { text in
                        print(text)
                    }, onCommit: {
                        print("commit ed")
                    })
                }

                ListSection(title: "Hello World", style: .shadow) {
                    ListButtonStandard(title: "Come one man", systemImage: "safari", isLast: false, style: .shadow, action: {
                        print("Come")
                    })

                    ListButtonStandard(title: "Come one man", systemImage: "safari", isLast: true, style: .shadow, action: {
                        print("Come")
                    })
                }

                ListSection(title: "Hello World", style: .border) {
                    ListButtonStandard(title: "add up man", systemImage: "safari", isLast: false, style: .border, action: {
                        print("Come")
                        ethAddressLength += 5.483
                    })

                    ListButtonStandard(title: "sub down man", systemImage: "safari", isLast: true, style: .border, action: {
                        print("Come")
                        ethAddressLength -= 8.624

                    })
                }

            }
        }
        .navigationTitle("Create Wallet")
        #if os(iOS)
        .navigationBarBackButtonHidden(!doneGenerating)
        #endif
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + services.userOnboarding.generateWalletDelay) {
                doneGenerating = true
                self.timer.upstream.connect().cancel()
            }
        }
        .onDisappear {
            self.timer.upstream.connect().cancel()
        }
    }

    private func customLabelMapping(_ label: String) -> String {
        guard let number = Int(label) else { return label }
        let emojis = ["d", "t", "S", "3", "P", "k", "b", "2", "a", "z", "b", "5"]
        return emojis[number]
    }

}
