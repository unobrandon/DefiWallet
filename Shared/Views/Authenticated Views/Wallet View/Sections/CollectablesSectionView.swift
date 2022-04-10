//
//  CollectablesSectionView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 4/10/22.
//

import SwiftUI

struct CollectablesSectionView: View {

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @EnvironmentObject private var walletRouter: WalletCoordinator.Router

    @ObservedObject private var service: AuthenticatedServices
    @ObservedObject private var store: WalletService

    @Binding private var isLoading: Bool

    init(isLoading: Binding<Bool>, service: AuthenticatedServices) {
        self._isLoading = isLoading
        self.service = service
        self.store = service.wallet
    }

    var body: some View {
        LazyVStack(alignment: .center, spacing: 0) {
            SectionHeaderView(title: "Collectables", action: {
                print("see more")
            })
            .padding(.vertical, 5)

            if isLoading, store.completeBalance.isEmpty {
                LoadingView(title: "")
            }

            
        }
    }

}
