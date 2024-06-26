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

    init(title: String? = "") {
        self.title = title ?? ""
    }

    var body: some View {
        HStack {
            Spacer()
            VStack(spacing: 5) {
                ActivityIndicator().animated(true).style(.regular)

                if title != "" {
                    Text(title).fontTemplate(DefaultTemplate.caption)
                }
            }
            Spacer()
        }.padding(.vertical)
    }

}
