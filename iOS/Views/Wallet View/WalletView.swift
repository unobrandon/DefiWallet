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
            VStack(alignment: .leading, spacing: 5) {
                Text("Welcome to \nthe wallet view")
                    .fontTemplate(DefaultTemplates.title)

                Text("The Header is here")
                    .fontTemplate(DefaultTemplates.heading)

                Text("The Sub-Header is here")
                    .fontTemplate(DefaultTemplates.subheading)

                Text("The body texts!!")
                    .fontTemplate(DefaultTemplates.body)

                Text("caption timee")
                    .fontTemplate(DefaultTemplates.caption)
            }.frame(width: MobileConstants.screenWidth)

            RoundedRectangle(cornerRadius: 10)
                .frame(width: 100, height: 800, alignment: .center)
                .foregroundColor(.red)
                .padding(.vertical, 50)
        }
        .navigationTitle("Wallet")
    }

}
