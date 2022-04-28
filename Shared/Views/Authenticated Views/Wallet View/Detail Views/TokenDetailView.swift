//
//  TokenDetailView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 4/11/22.
//

import SwiftUI

struct TokenDetailView: View {

    @EnvironmentObject private var walletRouter: WalletCoordinator.Router

    @ObservedObject private var service: AuthenticatedServices
    @ObservedObject private var store: WalletService
    private let balance: CompleteBalance
    private let network: Network?

    @State private var headerOffsets: (CGFloat, CGFloat) = (0, 0)
    @State private var currentTab: String = "All"
    @State private var showSheet = false
    @State var isHistoryLoading = false
    @State private var gridViews: [AnyView] = []

    init(data: CompleteBalance, network: Network? = nil, service: AuthenticatedServices) {
        self.balance = data
        self.network = network
        self.service = service
        self.store = service.wallet
    }

    var body: some View {
        BackgroundColorView(style: service.themeStyle, {
            ScrollView(.vertical, showsIndicators: false) {
                Text("hello")
            }
        })
    }

}
