//
//  WalletNavigationView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 3/15/22.
//

import SwiftUI

struct WalletNavigationView: View {

    private let service: AuthenticatedServices

    @State var connectionStatus: String = "booting..."

    init(service: AuthenticatedServices) {
        self.service = service
    }

    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            UserAvatar(size: 34, user: service.currentUser, style: service.themeStyle)

            VStack(alignment: .leading, spacing: 2) {
                HStack(alignment: .center, spacing: 5) {
                    Circle()
                        .frame(width: 8, height: 8, alignment: .center)
                        .foregroundColor(service.ethereum.ethNetworkStatus == .connected ? .green : service.ethereum.ethNetworkStatus == .connecting ? .orange : .red)

                    Text(connectionStatus)
                        .fontTemplate(DefaultTemplate.bodySemibold)
                }

                Text(service.currentUser.username ?? service.currentUser.shortAddress)
                    .fontTemplate(DefaultTemplate.bodyMono_secondary)
            }
        }
        .padding(.trailing)
        .onReceive(service.ethereum.$ethNetworkStatus, perform: { status in
            switch status {
            case .error:
                connectionStatus = "error"
            case .undefined:
                connectionStatus = "undefined error"
            case .connecting:
                connectionStatus = "connecting..."
            case .connected:
                connectionStatus = "connected"
            case .disconnected:
                connectionStatus = "disconnected"
            }
            })
    }
}
