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

struct ScanQRView: View {

    @ObservedObject private var service: AuthenticatedServices
    @ObservedObject private var store: WalletService

    @Binding var showSheet: Bool
    @State private var torchIsOn = false
    @State private var foundLink = false
    @State private var doneSuccess = false

    private let actionScan: (String) -> Void

    init(showSheet: Binding<Bool>, service: AuthenticatedServices, actionScan: @escaping (String) -> Void) {
        self.actionScan = actionScan
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

            Text(foundLink ? "Do you want to connect and give the following Dapp access to your wallet?" : "Scan any Dapp's QR code to connect your wallet. Learn more here.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .padding(.bottom, 10)

            Spacer()
            if !foundLink {
                ZStack(alignment: .bottomTrailing) {
                    CBScanner(supportBarcode: .constant([.qr, .code128]), torchLightIsOn: self.$torchIsOn, scanInterval: .constant(0.5)) {
                        guard !self.foundLink else { return }

                        UINotificationFeedbackGenerator().notificationOccurred(.success)
                        self.actionScan($0.value)
                        self.foundLink = true

                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            self.doneSuccess = true
                        }
                        print("have received incoming link!: \(String(describing: $0.value))")
                    }
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
            }

            if self.foundLink, !doneSuccess {
                CheckmarkView(size: 50, color: .green).padding(10)

                Text("Success!")
                    .fontTemplate(DefaultTemplate.subheadingMedium)
            } else if self.foundLink, doneSuccess, let proposal = store.walletConnectProposal?.proposer {
                VStack(alignment: .center, spacing: 10) {
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
                        })
                    }
                }
            }

            Spacer()
            if doneSuccess {
                RoundedButton("Connect Dapp", style: .primary, systemImage: nil, action: {
                    guard let proposal = store.walletConnectProposal else {
                        return
                    }

                    DispatchQueue.main.async {
                        store.walletConnectClient.approve(proposal: proposal, accounts: [])
                    }
                })

                RoundedButton("Reject", style: .secondary, systemImage: nil, action: {
                    guard let proposal = store.walletConnectProposal else {
                        return
                    }

                    DispatchQueue.main.async {
                        store.walletConnectClient.reject(proposal: proposal, reason: .disapprovedChains)
                    }
                })
            }

            Text("powered by WalletConnect")
                .fontTemplate(DefaultTemplate.bodyMedium_standard)
        }
    }

}
