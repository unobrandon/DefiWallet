//
//  ScanQRView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 3/19/22.
//

import WalletConnectUtils
import SwiftUI
import SwiftUIX
import WalletConnect
import SDWebImageSwiftUI

struct ScanQRView: View {

    @ObservedObject private var service: AuthenticatedServices
    @ObservedObject private var store: WalletService

    @Binding var showSheet: Bool
    @State private var torchIsOn = false
    @State private var foundLink = false
    @State private var doneSuccess = false
    @State private var sessionExpired = false
    @State private var attempts: Int = 0

    init(showSheet: Binding<Bool>, service: AuthenticatedServices) {
        self.service = service
        self.store = service.wallet
        self._showSheet = showSheet
    }

    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Text(foundLink ? "Connect to Dapp" : "Scan QR Code")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primary)

            Text(foundLink ? "Do you want to connect and give the following Dapp access to your wallet?" : "Scan any address or WalletConnect Dapp's QR code to connect your wallet. Learn more here.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(3)
                .frame(height: 48)
                .padding(.horizontal)

            Spacer()
            if !foundLink {
                ZStack(alignment: .bottomTrailing) {
                    CBScanner(supportBarcode: .constant([.qr, .code128]), torchLightIsOn: self.$torchIsOn, scanInterval: .constant(0.5)) {
                        guard !self.foundLink else { return }

                        store.connectDapp(uri: $0.value, completion: { success in
                            if success, store.walletConnectProposal?.proposer.name != nil {
                                UINotificationFeedbackGenerator().notificationOccurred(.success)
                                self.foundLink = true
                                self.sessionExpired = false
                            } else {
                                guard !success, !sessionExpired else {
                                    self.sessionExpired = true

                                    return
                                }

                                self.attempts += 1
                                UINotificationFeedbackGenerator().notificationOccurred(.error)
                            }
                        })

                        print("have received incoming link!: \(String(describing: $0.value))")
                    }
                    .modifier(Shake(animatableData: CGFloat(attempts)))
                    .foregroundColor(Color("baseBackground"))
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.25), radius: 10, x: 0, y: 0)

                    Button(action: {
                        self.torchIsOn.toggle()
                        UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
                    }, label: {
                        ZStack {
                            VisualEffectBlurView(blurStyle: .systemUltraThinMaterial)
                                .frame(width: 50, height: 50)
                                .cornerRadius(15)
                                .foregroundColor(Color("baseBackground"))
                                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)

                            Image(systemName: self.torchIsOn ? "lightbulb.fill" : "lightbulb.slash.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.primary)
                                .frame(width: 25, height: 25, alignment: .center)
                        }
                    })
                    .padding(.all, 15)
                    .buttonStyle(ClickInteractiveStyle(0.97))
                }

                if sessionExpired {
                    Text("session expired, please refresh QR code").fontTemplate(DefaultTemplate.captionError)
                }
            }

            if self.foundLink, doneSuccess {
                CheckmarkView(size: 50, color: .green).padding(10)

                HStack {
                    Spacer()
                    Text("Success!").fontTemplate(DefaultTemplate.subheadingMedium)
                    Spacer()
                }
                Spacer()
            } else if self.foundLink, !doneSuccess, let proposal = store.walletConnectProposal?.proposer {
                VStack(alignment: .center, spacing: 10) {
                    if let imageUrl = proposal.url {
                        RemoteImage(imageUrl: imageUrl, size: 80)
                            .cornerRadius(10)
                    }

                    Text(proposal.name ?? "No name")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)

                    if let description = proposal.description {
                        Text(description)
                            .font(.subheadline)
                            .fontWeight(.none)
                            .foregroundColor(.secondary)
                    }

                    if let url = proposal.url {
                        BorderedButton(title: "Visit Website", systemImage: "safari", size: .small, action: {
                            UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
                            print("lets go visit this url: \(url)")
                        }).padding(.vertical, 5)
                    }

                    Spacer()
                    HStack(spacing: 10) {
                        Button("Reject", action: {
                            guard let proposal = store.walletConnectProposal else {
                                return
                            }

                            DispatchQueue.main.async {
                                store.walletConnectClient.reject(proposal: proposal, reason: .disapprovedChains)

                                SOCManager.dismiss(isPresented: $showSheet)
                                #if os(iOS)
                                    HapticFeedback.lightHapticFeedback()
                                #endif
                            }
                        }).buttonStyle(SOCAlternativeButton())

                        Button("Connect Dapp", action: {
                            guard let proposal = store.walletConnectProposal else {
                                return
                            }

                            DispatchQueue.main.async {
                                store.walletConnectClient.approve(proposal: proposal, accounts: [])

                                if store.walletConnectProposal != nil {
                                    store.walletConnectProposal = nil
                                }
                                self.doneSuccess = true

                                #if os(iOS)
                                    HapticFeedback.successHapticFeedback()
                                #endif

                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                    SOCManager.dismiss(isPresented: $showSheet)
                                }
                            }
                        }).buttonStyle(SOCActionButton())
                    }

                    if store.walletConnectProposal != nil {
                        Text("powered by WalletConnect").fontTemplate(DefaultTemplate.caption)
                    }
                }
            }
        }
    }

}
