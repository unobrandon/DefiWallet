//
//  ScanQRView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 3/19/22.
//

import SwiftUI

struct ScanQRView: View {

    @ObservedObject private var service: AuthenticatedServices
    @ObservedObject private var store: WalletService

    @Binding var showSheet: Bool
    @State var foundLink: Bool = false

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

            Text(foundLink ? "Do you want to connect and give the following Dapp access to your wallet's info?" : "Scan any address or WalletConnect Dapp's QR code to connect your wallet.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(3)
                .padding(.horizontal)
                .padding(.bottom, 40)

            if !foundLink {
                ScanQACameraView(foundLink: $foundLink, service: service)
            } else {
                DappProposalView(showSheet: $showSheet, service: service)
            }
        }
    }

}
