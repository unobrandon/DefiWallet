//
//  WalletNavigationView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 3/15/22.
//

import SwiftUI

struct WalletNavigationView: View {

    private let service: AuthenticatedServices

    @State var connectionStatus: String = "Welcome"
    @State var hasCopiedAddress: Bool = false

    init(service: AuthenticatedServices) {
        self.service = service
    }

    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            ZStack {
                UserAvatar(size: 34, user: service.currentUser, style: service.themeStyle)

                Circle()
                    .stroke(Color("baseBackground_bordered"), lineWidth: 2)
                    .frame(width: 10, height: 10, alignment: .center)
                    .background(Circle().foregroundColor(service.ethereum.ethNetworkStatus == .connected ? .green : service.ethereum.ethNetworkStatus == .connecting ? .orange : .red))
                    .offset(x: 12, y: 12)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(connectionStatus)
                    .fontTemplate(DefaultTemplate.bodySemibold)

                Button(action: {
                    UIPasteboard.general.string = service.currentUser.address
                    UINotificationFeedbackGenerator().notificationOccurred(.success)
                    withAnimation {
                        hasCopiedAddress = true
                    }

                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                        withAnimation {
                            hasCopiedAddress = false
                        }
                    }
                }, label: {
                    HStack(alignment: .center, spacing: 5) {
                        Text(service.currentUser.username ?? service.currentUser.shortAddress)
                            .fontTemplate(FontTemplate(font: Font.custom("LabMono-Regular", size: 12), weight: .regular, foregroundColor: .secondary, lineSpacing: 0))

                        Image(systemName: hasCopiedAddress ? "checkmark" : "doc.on.doc")
                            .resizable()
                            .scaledToFit()
                            .frame(width: hasCopiedAddress ? 10 : 12.5, height: hasCopiedAddress ? 10 : 12.5, alignment: .center)
                            .font(Font.title.weight(.semibold))
                            .foregroundColor(.secondary)
                    }
                }).buttonStyle(ClickInteractiveStyle(0.99))
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

                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    withAnimation {
                        connectionStatus = "Welcome"
                    }
                }
            case .disconnected:
                connectionStatus = "disconnected"
            }
            })
    }
}
