//
//  TermsOfServiceButton.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/27/22.
//

import SwiftUI

struct TermsOfServiceButton: View {

    private let action: () -> Void

    init(action: @escaping () -> Void) {
        self.action = action
    }

    var body: some View {

            VStack(alignment: .center, spacing: 2) {
                Text("By continuing, you agree to \(Constants.projectName)'s")
                    .font(.system(size: 12))
                    .font(.footnote)
                    .foregroundColor(Color.secondary)
                    .lineLimit(1)
                    .multilineTextAlignment(.center)

                Button(action: { self.actionTap() }) {
                    Text("Terms of Service & Privacy Policy.")
                        .font(.system(size: 12))
                        .font(.footnote)
                        .foregroundColor(Color.blue)
                        .lineLimit(1)
                        .multilineTextAlignment(.center)
                    }
                    .buttonStyle(ClickInteractiveStyle())
            }.padding(.horizontal)
    }

    private func actionTap() {
        #if os(iOS)
            HapticFeedback.lightHapticFeedback()
        #endif

        action()
    }

}
