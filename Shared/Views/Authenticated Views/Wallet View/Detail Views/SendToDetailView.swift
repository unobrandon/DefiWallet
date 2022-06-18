//
//  SendToDetailView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 4/28/22.
//

import SwiftUI

struct SendToDetailView: View {

    @EnvironmentObject private var walletRouter: WalletCoordinator.Router

    @ObservedObject private var service: AuthenticatedServices
    @ObservedObject private var store: WalletService

    @State var isLoading: Bool = false
    @State var sendError: Bool = false
    @State var disablePrimaryAction: Bool = true

    var sendAddress: String

    init(address: String, service: AuthenticatedServices) {
        self.service = service
        self.store = service.wallet
        self.sendAddress = address
    }

    var body: some View {
        BackgroundColorView(style: service.themeStyle, {
            ScrollView {
                ListSection(style: service.themeStyle) {
                    Text("Hello world!").padding()
                }
            }

            Spacer()
            if isLoading {
                LoadingIndicator(size: 30).padding(.bottom, 30)
            } else {
                if sendError {
                    Text("error occurred, please try again")
                        .fontTemplate(DefaultTemplate.captionError)
                        .padding(.bottom)
                }
            }
        })
        .navigationBarTitle("to: " + sendAddress.formatAddress(), displayMode: .inline)
        .onAppear {
            DispatchQueue.main.async {
                Tool.hiddenTabBar()
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                RoundedInteractiveButton("Approve", isDisabled: $disablePrimaryAction, style: .primary, systemImage: "paperplane.fill", action: {
                    print("send token to address:")
                })
            }
        }

    }

}
