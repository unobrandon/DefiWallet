//
//  PrivateKeysView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 3/2/22.
//

import SwiftUI

struct PrivateKeysView: View {

    @EnvironmentObject private var unauthenticatedRouter: UnauthenticatedCoordinator.Router

    @ObservedObject private var store: UnauthenticatedServices

    @State private var keyHidden: Bool = true
    @State private var didCopy: Bool = false

    private let alertMessage = "Never share your recovery phrase with anyone! Store this phrase in a safe place."

    init(services: UnauthenticatedServices) {
        self.store = services
    }

    var body: some View {
        ZStack(alignment: .center) {
            Color("baseBackground").ignoresSafeArea()

            VStack(alignment: .center, spacing: 0) {
                Spacer()

                HeaderIcon(size: 48, imageName: "key")
                    .rotationEffect(.init(degrees: 45))

                Text("Recovery Phrase")
                    .fontTemplate(DefaultTemplate.headingSemiBold)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 10)

                Text("Write down or copy these words in the right order.")
                    .fontTemplate(DefaultTemplate.bodyMono_secondary)
                    .multilineTextAlignment(.center)

                Spacer()
                AlertBanner(message: alertMessage, color: .orange)

                ListSection(title: store.unauthenticatedWallet.address.formatAddressExtended(), style: .border, {
                    HStack(alignment: .top, spacing: 0) {
                        Spacer()

                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(0...5, id: \.self) { index in
                                Text("\(index + 1).) \(store.secretPhrase[index])")
                                    .fontTemplate(DefaultTemplate.monospaceBody)
                                    .padding(7.5)
                                    .background(RoundedRectangle(cornerRadius: 4).foregroundColor(Color("baseButton")))
                            }.blur(radius: keyHidden ? 15 : 0)
                        }

                        Spacer()
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(6...11, id: \.self) { index in
                                Text("\(index + 1).) \(store.secretPhrase[index])")
                                    .fontTemplate(DefaultTemplate.monospaceBody)
                                    .padding(7.5)
                                    .background(RoundedRectangle(cornerRadius: 4).foregroundColor(Color("baseButton")))
                            }.blur(radius: keyHidden ? 15 : 0)
                        }

                        Spacer()
                    }.padding(.vertical)
                    .overlay(
                        VStack(alignment: .center, spacing: 10) {
                            Image(systemName: "hand.tap")
                                .resizable()
                                .scaledToFit()
                                .font(Font.title.weight(.medium))
                                .foregroundColor(.primary)
                                .frame(width: 38, height: 38, alignment: .center)

                            Text("Tap and hold to view phrase")
                                .fontTemplate(DefaultTemplate.bodyBold)
                        }.opacity(keyHidden ? 1 : 0)
                    )
                })
                .padding(.bottom, 5)
                .onLongPressGesture(minimumDuration: 0.2) {
                    keyHidden.toggle()
                }

                HStack(alignment: .top, spacing: 5) {
                    Text("\(Constants.projectName) will never ask for your recovery phrase")
                        .fontTemplate(DefaultTemplate.caption)
                        .multilineTextAlignment(.leading)

                    Spacer()
                    Button(action: {
                        store.copyPrivateKey()
                        withAnimation {
                            didCopy = true
                        }

                        #if os(iOS)
                            HapticFeedback.successHapticFeedback()
                        #endif
                    }, label: {
                        Label(didCopy ? "Copied" : "Copy", systemImage: didCopy ? "checkmark" : "doc.on.doc")
                    })
                    .buttonStyle(.bordered)
                    .controlSize(.mini)
                    .buttonBorderShape(.roundedRectangle)
                }

                Spacer()
                RoundedButton("Next", style: .primary, systemImage: nil, action: {
                    unauthenticatedRouter.route(to: \.setPassword)
                })
                .padding(.bottom, 10)
            }.padding(.horizontal)
        }.navigationBarTitle("Secure Your Keys", displayMode: .inline)
    }

}
