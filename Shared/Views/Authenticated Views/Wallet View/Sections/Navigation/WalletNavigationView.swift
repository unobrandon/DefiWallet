//
//  WalletNavigationView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 3/15/22.
//

import SwiftUI

struct WalletNavigationView: View {

    private let service: AuthenticatedServices
    @ObservedObject private var store: WalletService
    @Binding var scrollOffset: CGFloat

    @State var connectionStatus: String = ""
    @State var hasCopiedAddress: Bool = false

    init(service: AuthenticatedServices, scrollOffset: Binding<CGFloat>) {
        self.service = service
        self.store = service.wallet
        self._scrollOffset = scrollOffset
        self.connectionStatus = getWelcome()
    }

    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            ZStack {
                if let sessions = store.wcActiveSessions, !sessions.isEmpty {
                    Menu {
                        ForEach(sessions.indices, id: \.self) { session in
                            Button("Disconnect \(sessions[session].name)", action: {
//								store.disconnectDapp(sessionTopic: sessions[session].topic)
							})
                        }
                    } label: {
                        ZStack(alignment: .center) {
                            ForEach(sessions.prefix(3).indices, id: \.self) { session in
                                RemoteImage(sessions[session].iconURL, size: 36)
                                    .overlay(Circle().foregroundColor(.clear).overlay(Circle().strokeBorder(Color("baseBackground_bordered"), lineWidth: 4)))
                                    .padding(.leading, CGFloat(25 * session))
                            }
                        }
                    }
                } else {
                    UserAvatar(size: 34, user: service.currentUser, style: service.themeStyle)
                }

                Circle()
                    .strokeBorder(Color("baseBackground_bordered"), lineWidth: 2)
                    .frame(width: 10, height: 10, alignment: .center)
                    .background(Circle().foregroundColor(store.networkStatus == .connected ? .green : store.networkStatus == .connecting ? .orange : .red))
                    .offset(x: 12, y: 12)
            }

            VStack(alignment: .leading, spacing: 2) {
                if let session = store.wcActiveSessions.first {
                    let others = (store.wcActiveSessions.count <= 1 ? "" : " & \(store.wcActiveSessions.count - 1) other" + (store.wcActiveSessions.count == 2 ? "" : "s"))
                    Text(session.name + others)
                        .fontTemplate(DefaultTemplate.bodyBold)
                } else {
                    if self.scrollOffset > 68, store.networkStatus == .connected {
                        HStack(alignment: .center, spacing: 0) {
                            Text(Locale.current.currencySymbol ?? "").fontTemplate(DefaultTemplate.bodyBold)

                            MovingNumbersView(number: store.accountBalance?.portfolioTotal ?? 0.00,
                                              numberOfDecimalPlaces: 2,
                                              fixedWidth: nil,
                                              theme: DefaultTemplate.bodyBold,
                                              animationDuration: 0.4,
                                              showComma: true) { str in
                                Text(str).fontTemplate(DefaultTemplate.bodyBold)
                            }
                        }
                    } else {
                        Text(connectionStatus).fontTemplate(DefaultTemplate.bodyBold)
                    }
                }

                Button(action: {
                    UIPasteboard.general.string = service.currentUser.address
                    HapticFeedback.successHapticFeedback()
                    showNotiHUD(image: "doc.on.doc", color: Color("AccentColor"), title: "Copied wallet address", subtitle: nil)
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
                        Text(service.currentUser.username == service.currentUser.address ? service.currentUser.shortAddress : service.currentUser.username ?? service.currentUser.shortAddress)
                            .fontTemplate(FontTemplate(font: Font.custom("LabMono-Regular", size: 12), weight: .regular, foregroundColor: .secondary, lineSpacing: 0))

                        Image(systemName: hasCopiedAddress ? "checkmark" : "doc.on.doc")
                            .resizable()
                            .scaledToFit()
                            .frame(width: hasCopiedAddress ? 10 : 12.5, height: hasCopiedAddress ? 10 : 12.5, alignment: .center)
                            .font(Font.title.weight(.semibold))
                            .foregroundColor(.secondary)
                    }
                }).buttonStyle(ClickInteractiveStyle(0.95))
            }
        }
        .padding(.trailing)
        .onReceive(store.$networkStatus, perform: { status in
            switch status {
            case .connecting:
                connectionStatus = "connecting..."
            case .reconnecting:
                connectionStatus = "re-connecting..."
            case .connected:
                connectionStatus = "connected"

                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    withAnimation {
                        connectionStatus = getWelcome()
                    }
                }
            case .offline:
                connectionStatus = "offline"
            case .unknown:
                connectionStatus = "major issue"
            }
            })
    }

    private func getWelcome() -> String {
        var welcomeMsg = ""

        if let appOpenCount = UserDefaults.standard.value(forKey: "APP_OPENED_COUNT") as? Int {
            welcomeMsg = appOpenCount < 1 ? "Welcome Back," : "Welcome 👋,"
        } else {
            welcomeMsg = "Welcome 👋"
        }

        return welcomeMsg
    }

}
