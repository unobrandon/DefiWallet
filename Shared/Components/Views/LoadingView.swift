//
//  LoadingView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 3/22/22.
//

import SwiftUI
import SwiftUIX

struct LoadingView: View {

    private let title: String

    init(title: String) {
        self.title = title
    }

    var body: some View {
        VStack(spacing: 10) {
            ActivityIndicator().animated(true).style(.regular)

            HStack {
                Spacer()
                if title != "" {
                    Text(title).fontTemplate(DefaultTemplate.caption)
                }
                Spacer()
            }
        }.padding(.vertical)
    }

}
