//
//  TokenDetailNetworkSection.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 5/26/22.
//

import SwiftUI

extension TokenDetailView {

    @ViewBuilder
    func detailsNetworkSection() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("networks:")
                .font(.caption)
                .fontWeight(.regular)
                .textCase(.uppercase)
                .foregroundColor(.secondary)
                .padding(.horizontal)
        }
        .padding(.bottom)
        .padding(.horizontal)
    }

}
