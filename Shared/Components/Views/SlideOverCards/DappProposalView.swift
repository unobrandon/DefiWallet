//
//  DappProposalView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 3/20/22.
//

import SwiftUI

struct DappProposalView: View {

    @ObservedObject private var service: AuthenticatedServices
    @ObservedObject private var store: WalletService

    @Binding var showSheet: Bool
    @State private var doneSuccess = false

    init(showSheet: Binding<Bool>, service: AuthenticatedServices) {
        self.service = service
        self.store = service.wallet
        self._showSheet = showSheet
    }

    var body: some View {
        /*
        if doneSuccess {
            CheckmarkView(size: 50, color: .green).padding(10)

            HStack {
                Spacer()
                Text("Success!").fontTemplate(DefaultTemplate.subheadingMedium)
                Spacer()
            }
            Spacer()
        } else if !doneSuccess, let proposal = store.wcProposal?.proposer {
            VStack(alignment: .center, spacing: 10) {
                if let imageUrl = proposal.icons?.first {
                    RemoteImage(imageUrl, size: 80)
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
                        guard let proposal = store.wcProposal else {
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
                        guard let proposal = store.wcProposal else {
                            return
                        }

                        DispatchQueue.main.async {
                            guard let account = Account("eip155:1:" + service.currentUser.address) else {
                                HapticFeedback.errorHapticFeedback()

                                return
                            }

                            store.walletConnectClient.approve(proposal: proposal, accounts: [account])

                            if store.wcProposal != nil {
                                store.wcProposal = nil
                            }
                            self.doneSuccess = true

                            #if os(iOS)
                                HapticFeedback.successHapticFeedback()
                            #endif

                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                                SOCManager.dismiss(isPresented: $showSheet)
                            }
                        }
                    }).buttonStyle(SOCActionButton())
                }

                if store.wcProposal != nil {
                    Text("powered by WalletConnect").fontTemplate(DefaultTemplate.caption)
                }
            }
        }
         */
        Text("hello")
    }

}
