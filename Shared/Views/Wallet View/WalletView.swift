//
//  WalletView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/13/22.
//

import SwiftUI
import Stinsen

struct WalletView: View {

    init() {

    }

    var body: some View {
        ScrollView {
            Text("Welcome to the wallet view")

            RoundedRectangle(cornerRadius: 10)
                .frame(width: 100, height: 800, alignment: .center)
                .foregroundColor(.red)
                .padding(.vertical, 50)
        }
        .navigationTitle("Wallet")
    }

}
